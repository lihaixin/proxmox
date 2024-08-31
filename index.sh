#!/bin/bash
get_system_info () {
echo "获取系统信息中..."

    # 获取公网IP地址
    export WANIP=""
    [[ -z $WANIP ]] &&WANIP=$(curl --max-time 5 -s https://ipinfo.io/ip)
    [[ -z $WANIP ]] &&WANIP=$(curl --max-time 5 -s https://api.ipify.org)
    [[ -z $WANIP ]] &&WANIP=$(curl --max-time 5 -s https://ifconfig.co/ip)
    [[ -z $WANIP ]] &&WANIP=$(curl --max-time 5 -s https://api.myip.com | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
    [[ -z $WANIP ]] &&WANIP=$(curl --max-time 5 -s icanhazip.com)
    [[ -z $WANIP ]] &&WANIP=$(curl --max-time 5 -s myip.ipip.net | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
    [[ -z $WANIP ]] &&printecho 3 "Container network is not working!" &&exit
    echo "IP地址: $WANIP"

    # 获取IP所属国家，这里使用ipinfo.io和ipapi.co作为示例，需确保符合使用条款
    export COUNTRY=""
    COUNTRY=$(curl --max-time 5 ipinfo.io/country  2>/dev/null || curl --max-time 5 https://ipapi.co/country 2>/dev/null)
    COUNTRY=`echo $COUNTRY | tr A-Z a-z`
    echo "IP所属国家: $COUNTRY"

    # 获取内存大小
    export MEM_INFO=""
    MEM_INFO=$(free -m)
    MEM_TOTAL=$(echo "$MEM_INFO" | grep Mem | awk '{print $2}')
    echo "内存大小(MB): $MEM_TOTAL"

    # 获取磁盘总大小，这里以根目录为例
    export DISK_TOTAL=""
    DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
    echo "磁盘大小: $DISK_TOTAL"

    # 检测是否为虚拟机，此处简化处理，仅检测常见的虚拟化平台标识文件
    export VIRTUAL_PLATFORM=""
    if [ -f "/sys/class/dmi/id/product_name" ]; then
        VIRTUAL_PLATFORM=$(cat /sys/class/dmi/id/product_name)
        VIRTUAL_PLATFORM="是 $VIRTUAL_PLATFORM " 
        echo "虚拟平台: $VIRTUAL_PLATFORM " 
    else
        VIRTUAL_PLATFORM="否 物理机"
        echo "虚拟平台: $VIRTUAL_PLATFORM "
    fi
  }

main_menu() {
    clear
    echo "################################################################"
    echo "#   欢迎访问  https://bash.15099.net 脚本管理系统                #"
    echo "#   主机是否为虚拟平台：$VIRTUAL_PLATFORM                        #"
    echo "#   主机内存大小(MB): $MEM_TOTAL 磁盘大小: $DISK_TOTAL           #"
    echo "#   主机IP地址: $WANIP        IP所属国家: $COUNTRY               #"
    echo "################################################################"
    echo "请选择一个操作:"
    echo "1) 运行在线脚本1"
    echo "2) 运行在线脚本2"
    echo "3) 运行在线脚本3"
    echo "0) 返回上级菜单"
    read -p "输入选项: " choice
    case $choice in
        1) run_script1 ;;
        2) run_script2 ;;
        3) run_script3 ;;
        0) exit 0 ;;
        *) echo "无效的选项，请重新选择。"; sleep 2; main_menu ;;
    esac
}

run_script1() {
    echo "正在运行在线脚本1..."
    # 这里放置执行脚本1的代码，例如通过curl或wget获取并执行
    # 示例：curl -sL https://someurl/script1.sh | bash
    echo "脚本1执行完毕，按回车键继续。"
    read
    main_menu
}

run_script2() {
    echo "正在运行在线脚本2..."
    # 同样，这里插入脚本2的执行逻辑
    echo "脚本2执行完毕，按回车键继续。"
    read
    main_menu
}

run_script3() {
    echo "正在运行在线脚本3..."
    # 插入脚本3的执行逻辑
    echo "脚本3执行完毕，按回车键继续。"
    read
    main_menu
}

# 主程序开始
get_system_info
clear
while true; do
    main_menu
done
