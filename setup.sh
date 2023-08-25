#!/bin/bash

if [ ! $(command -v docker) ]; then
	curl -sSLk https://get.docker.com/ | bash
	if [ $? -ne "0" ]; then
		echo -e "\t Docker 安装失败"
		exit 1
	fi
	systemctl start docker && systemctl enable docker
fi
if [ $(command -v docker-compose) ]; then
	DC_CMD="docker-compose"
else
	DC_CMD="docker compose"
fi

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd  "$SCRIPT_PATH"

uninstall_tianji(){
	$DC_CMD down > /dev/null 2>&1
	docker rm tj-osg tj-db > /dev/null 2>&1
	docker network rm tjnet > /dev/null 2>&1
	docker images|grep tianji|awk '{print $3}'|xargs docker rmi -f
	docker volume ls|grep tjosg|awk '{print $2}'|xargs docker volume rm -f
}

start_tianji(){
	if [ $(command -v netstat) ]; then
		port_status=`netstat -nlt|grep -E ':(80|443)\s'|wc -l`
		if [ $port_status -gt 0 ]; then
			echo -e "\t 端口80、443中的一个或多个被占用，请关闭对应服务或修改其端口"
			exit 1
		fi
	fi
	$DC_CMD up -d
}

stop_tianji(){
	$DC_CMD down
}

clean_tianji(){
	docker system prune -a -f
	docker volume prune -f
}

start_menu(){
    clear
    echo "========================="
    echo "天机办公安全平台管理"
    echo "========================="
    echo "1. 启动"
    echo "2. 停止"
    echo "3. 卸载"
    echo "4. 清理"
    echo "5. 退出"
    echo
    read -p "请输入数字:" num
    case "$num" in
    	1)
	start_tianji
	echo "启动完成"
	;;
	2)
	stop_tianji
	echo "停止完成"
	;;
    	3)
	uninstall_tianji
	echo "卸载完成"
	;;
	4)
	clean_tianji
	echo "清理完成"
	;;
	5)
	exit 1
	;;
	*)
	clear
	echo "请输入正确数字"
	;;
    esac
    sleep 3s
    clear
    start_menu
}

start_menu
