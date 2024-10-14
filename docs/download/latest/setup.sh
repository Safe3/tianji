#!/bin/bash

echo "
  _____  ___     _     _   _      _  ___ 
 |_   _||_ _|   / \   | \ | |    | ||_ _|
   | |   | |   / _ \  |  \| | _  | | | | 
   | |   | |  / ___ \ | |\  || |_| | | | 
   |_|  |___|/_/   \_\|_| \_| \___/ |___|
"

confirm() {
    echo -e -n "\033[34m[天机] $* \033[1;36m(Y/n)\033[0m"
    read -n 1 -s opt

    [[ "$opt" == $'\n' ]] || echo

    case "$opt" in
        'y' | 'Y' ) return 0;;
        'n' | 'N' ) return 1;;
        *) confirm "$1";;
    esac
}

info() {
    echo -e "\033[37m[天机] $*\033[0m"
}

warning() {
    echo -e "\033[33m[天机] $*\033[0m"
}

abort() {
    qrcode
    echo -e "\033[31m[天机] $*\033[0m"
    exit 1
}

command_exists() {
	command -v "$1" 2>&1
}

check_container_health() {
    local container_name=$1
    local max_retry=30
    local retry=0
    local health_status="unhealthy"
    info "Waiting for $container_name to be healthy"
    while [[ "$health_status" == "unhealthy" && $retry -lt $max_retry ]]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' $container_name 2>/dev/null || info 'unhealthy')
        sleep 5
        retry=$((retry+1))
    done
    if [[ "$health_status" == "unhealthy" ]]; then
        abort "Container $container_name is unhealthy"
    fi
    info "Container $container_name is healthy"
}

space_left() {
    dir="$1"
    while [ ! -d "$dir" ]; do
        dir=`dirname "$dir"`;
    done
    echo `df -h "$dir" --output='avail' | tail -n 1`
}

local_ips() {
    if [ -z `command_exists ip` ]; then
        ip_cmd="ip addr show"
    else
        ip_cmd="ifconfig -a"
    fi

    echo $($ip_cmd | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | awk '{print $2}')
}

get_average_delay() {
    local source=$1
    local total_delay=0
    local iterations=3

    for ((i = 0; i < iterations; i++)); do
        # check timeout
        if ! curl -o /dev/null -m 1 -s -w "%{http_code}\n" "$source" > /dev/null; then
            delay=999
        else
            delay=$(curl -o /dev/null -s -w "%{time_total}\n" "$source")
        fi
        total_delay=$(awk "BEGIN {print $total_delay + $delay}")
    done

    average_delay=$(awk "BEGIN {print $total_delay / $iterations}")
    echo "$average_delay"
}

install_docker() {
    curl -fsSL "https://tianji.uusec.com/download/latest/get-docker.sh" -o get-docker.sh
    sources=(
        "https://mirrors.aliyun.com/docker-ce"
        "https://mirrors.tencent.com/docker-ce"
        "https://download.docker.com"
    )
    min_delay=${#sources[@]}
    selected_source=""
    for source in "${sources[@]}"; do
        average_delay=$(get_average_delay "$source")
        echo "source: $source, delay: $average_delay"
        if (( $(awk 'BEGIN { print '"$average_delay"' < '"$min_delay"' }') )); then
            min_delay=$average_delay
            selected_source=$source
        fi
    done

    echo "selected source: $selected_source"
    export DOWNLOAD_URL="$selected_source"
    bash get-docker.sh

    start_docker
    docker version > /dev/null 2>&1
    if [ $? -ne "0" ]; then
        echo "Docker 安装失败, 请检查网络连接或手动安装 Docker"
        echo "参考文档: https://docs.docker.com/engine/install/"
        abort "Docker 安装失败"
    fi
    info "Docker 安装成功"
}

start_docker() {
    systemctl enable docker
    systemctl daemon-reload
    systemctl start docker
}

check_depend() {
    # CPU ssse3 指令集检查
    support_ssse3=1
    lscpu | grep ssse3 > /dev/null 2>&1
    if [ $? -ne "0" ]; then
        echo "not found info in lscpu"
        support_ssse3=0
    fi
    cat /proc/cpuinfo | grep ssse3 > /dev/null 2>&1
    if [ $support_ssse3 -eq "0" -a $? -ne "0" ]; then
      abort "雷池需要运行在支持 ssse3 指令集的 CPU 上，虚拟机请自行配置开启 CPU ssse3 指令集支持"
    fi
    if [ -z "$BASH" ]; then
        abort "请用 bash 执行本脚本，请参考最新的官方技术文档 https://tianji.uusec.com/"
    fi

    if [ ! -t 0 ]; then
        abort "STDIN 不是标准的输入设备，请参考最新的官方技术文档 https://tianji.uusec.com/"
    fi

    if [ "$EUID" -ne "0" ]; then
        abort "请以 root 权限运行"
    fi

    if [ -z `command_exists docker` ]; then
        warning "缺少 Docker 环境"
        if confirm "是否需要自动安装 Docker"; then
            install_docker
        else
            abort "中止安装"
        fi
    fi

    info "发现 Docker 环境: '`command -v docker`'"

    docker version > /dev/null 2>&1
    if [ $? -ne "0" ]; then
        abort "Docker 服务工作异常"
    fi

    compose_command="docker compose"
    if $compose_command version; then
        info "发现 Docker Compose Plugin"
    else
        warning "未发现 Docker Compose Plugin"
        if confirm "是否需要自动安装 Docker Compose Plugin"; then
            install_docker
            if [ $? -ne "0" ]; then
                abort "Docker Compose Plugin 安装失败"
            fi
            info "Docker Compose Plugin 安装完成"
        else
            abort "中止安装"
        fi
    fi

    # check docker compose support -d
    if ! $compose_command up -d --help > /dev/null 2>&1; then
        warning "Docker Compose Plugin 不支持 '-d' 参数"
        if confirm "是否需要自动升级 Docker Compose Plugin"; then
            install_docker
            if [ $? -ne "0" ]; then
                abort "Docker Compose Plugin 升级失败"
            fi
            info "Docker Compose Plugin 升级完成"
        else
            abort "中止安装"
        fi
    fi

    start_docker

    info "安装环境确认正常"
}

# 定义resolv.conf文件路径
RESOLV_CONF="/etc/resolv.conf"

# 检查resolv.conf文件中是否包含无效的IPv6地址格式
check_ipv6_format() {
    grep -E 'nameserver\s+[0-9a-fA-F:]+%[0-9a-zA-Z]*$' "$RESOLV_CONF" > /dev/null
    if [ $? -eq 0 ]; then
        echo "检测到无效的IPv6地址格式（包含区域索引）。"
        return 1
    fi
    return 0
}

# 提示用户进行修改
suggest_fix_ipv6() {
    echo "请手动修改 $RESOLV_CONF 文件中的无效IPv6地址格式。"
    echo "例如，移除区域索引部分："
    echo "将 'fe80::46d9:e7ff:fe95:e3db%br0' 修改为 'fe80::46d9:e7ff:fe95:e3db'"
    abort "需要手动修改 $RESOLV_CONF 文件中的无效IPv6地址格式"
}

trap 'onexit' INT
onexit() {
    echo
    abort "用户手动结束安装"
}

check_depend

check_ipv6_format
if [ $? -eq 1 ]; then
    suggest_fix_ipv6
fi

docker network rm tianji-net 2>/dev/null

ips=`local_ips`
subnets="172.22.222 169.254.222 192.168.222"

for subnet in $subnets; do
    if [[ $ips != *$subnet* ]]; then
        SUBNET_PREFIX=$subnet
        break
    fi
done

if [ -z `command_exists netstat` ]; then
    $( command -v yum || command -v apt-get ) install -y net-tools
fi
port_status=`netstat -nltu|grep -E ':(53|80|443|5432|33333)\s'|wc -l`
if [ $port_status -gt 0 ]; then
    abort "端口53、80、443、5432、33333中的一个或多个被占用，请关闭对应服务或修改其端口"
fi

tianji_path='/opt/tianji'

while true; do
    echo -e -n "\033[34m[天机] 安装目录 (留空则为 '$tianji_path'): \033[0m"
    read input_path
    [[ -z "$input_path" ]] && input_path=$tianji_path

    if [[ ! $input_path == /* ]]; then
        warning "'$input_path' 不是合法的绝对路径"
        continue
    fi

    if [ -f "$input_path" ] || [ -d "$input_path" ]; then
        warning "'$input_path' 路径已经存在，请换一个"
        continue
    fi

    tianji_path=$input_path

    if confirm "目录 '$tianji_path' 当前剩余存储空间为 `space_left \"$tianji_path\"` ，雷池至少需要 5G，是否确定"; then
        break
    fi
done

mkdir -p "$tianji_path"
if [ $? -ne "0" ]; then
    abort "创建安装目录 '$tianji_path' 失败"
fi
info "创建安装目录 '$tianji_path' 成功"
cd "$tianji_path"

curl "https://tianji.uusec.com/download/latest/compose.yaml" -sSLk -o compose.yaml
curl "https://tianji.uusec.com/download/latest/admin.sh" -sSLk -o admin.sh
chmod +x admin.sh

if [ $? -ne "0" ]; then
    abort "下载 compose.yaml 脚本失败"
fi
info "下载 compose.yaml 脚本成功"

touch ".env"
if [ $? -ne "0" ]; then
    abort "创建 .env 脚本失败"
fi
info "创建 .env 脚本成功"

echo "TIANJI_DIR=$tianji_path" >> .env
echo "IMAGE_TAG=latest" >>".env"
echo "POSTGRES_PASSWORD=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32)" >> .env
echo "SUBNET_PREFIX=$SUBNET_PREFIX" >> .env
echo "IMAGE_PREFIX=swr.cn-south-1.myhuaweicloud.com/uusec" >>".env"

echo -e -n "\033[34m[天机] 邮件服务器地址: \033[0m"
read tianji_mail_server
echo "TIANJI_MAIL_SERVER=$tianji_mail_server" >> .env
echo -e -n "\033[34m[天机] 邮件用户名称: \033[0m"
read tianji_mail_username
echo "TIANJI_MAIL_USERNAME=$tianji_mail_username" >> .env
echo -e -n "\033[34m[天机] 邮件用户密码: \033[0m"
read tianji_mail_password
echo "TIANJI_MAIL_PASSWORD=$tianji_mail_password" >> .env

info "即将开始下载 Docker 镜像"
$compose_command up -d

if [ $? -ne "0" ]; then
    abort "启动 Docker 容器失败"
fi

check_container_health tianji-pg

warning "天机办公安全网关社区版安装成功！"
warning "请安装配置客户端后访问以下地址访问控制台："
warning "https://tj.local/"
warning "天机Docker管理和更新请使用以下shell脚本："
warning "$tianji_path/admin.sh"
