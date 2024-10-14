#!/bin/bash

abort() {
	echo -e "\033[31m[天机] $*\033[0m"
	exit 1
}

if [ -z "$BASH" ]; then
	abort "请用 bash 执行本脚本，参考最新的官方技术文档 https://tianji.uusec.com/"
fi

if [ "$EUID" -ne "0" ]; then
	abort "请以 root 权限运行"
fi

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd  "$SCRIPT_PATH"

stop_tianji(){
	$DC_CMD down
}

uninstall_tianji(){
	stop_tianji
	docker rm -f tianji-osg tianji-pg > /dev/null 2>&1
	docker network rm tianji-net > /dev/null 2>&1
	docker images|grep tianji|awk '{print $3}'|xargs docker rmi -f > /dev/null 2>&1
	docker volume ls|grep tianji|awk '{print $2}'|xargs docker volume rm -f > /dev/null 2>&1
	rm -rf $SCRIPT_PATH
}

start_tianji(){
	if [ $(command -v netstat) ]; then
		port_status=`netstat -nltu|grep -E ':(53|80|443|5432|33333)\s'|wc -l`
		if [ $port_status -gt 0 ]; then
			echo -e "\t 端口53、80、443、5432、33333中的一个或多个被占用，请关闭对应服务或修改其端口"
			exit 1
		fi
	fi
	$DC_CMD up -d
}

update_tianji(){
	stop_tianji
	docker images|grep tianji|awk '{print $3}'|xargs docker rmi -f > /dev/null 2>&1
	start_tianji
}

restart_tianji(){
	stop_tianji
	start_tianji
}

clean_tianji(){
	docker system prune -a -f
	docker volume prune -a -f
}

start_menu(){
    clear
    echo "========================="
    echo "天机Docker管理"
    echo "========================="
    echo "1. 启动"
    echo "2. 停止"
    echo "3. 重启"
    echo "4. 更新"
    echo "5. 卸载"
    echo "6. 清理"
    echo "7. 退出"
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
	restart_tianji
	echo "重启完成"
	;;
	4)
	update_tianji
	echo "更新完成"
	;;
	5)
	uninstall_tianji
	echo "卸载完成"
	;;
	6)
	clean_tianji
	echo "清理完成"
	;;
	7)
	exit 1
	;;
	*)
	clear
	echo "请输入正确数字"
	;;
    esac
    sleep 3s
    start_menu
}

start_menu
