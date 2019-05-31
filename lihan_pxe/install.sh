#!/bin/bash
echo "欢迎使用我的PXE一键装机平台"
ipaddr=`ifconfig eth0 | awk '/inet /{print $2}'`
sleep 2
nopass(){
  echo "在安装PXE之前，你需要将pxe文件夹拷贝到你pxe服务器的根目录下"
  sleep 2
  if [ ! -d "/pxe" ];then
    echo "\033[31;1m你丫的不听话\033[0m"
    exit 1 
  fi
  echo "PXE服务器连接你FTP服务器[真机]不需要密码，所以要设置无密登录"
  sleep 2
  ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -N ''
  sleep 2
  echo "这里你要输入真机root的密码: teacher.com"
  ssh-copy-id 192.168.4.254
}
dhcpI(){
  echo "安装dhcp软件包"
  yum -y install dhcp  > /dev/null
  sleep 2
  echo "将confs文件夹中的dhcpd.conf配置发送到dhcp工作目录[默认网段是 192.168.4.0/24]"
  rm -rf /etc/dhcp/dhcpd.conf
  sed  "s/1.1.1.1/$ipaddr/" ./confs/dhcpd.conf > /etc/dhcp/dhcpd.conf
  echo "启动并开机自启dhcp"
  systemctl restart dhcpd > /dev/null
  systemctl enable dhcpd > /dev/null
  sleep 1
  echo "启动dhcp成功"
}
tftpI(){
  echo "安装tftp-server软件包"
  sleep 1
  tar -xf tftp.tar.gz 
  rm -rf tftp.tar.gz
  yum -y install tftp-server > /dev/null
  echo "拷贝引导文件(initrd.img)和内核文件(vmlinuz)"
  sleep 2
  mkdir /var/lib/tftpboot/centos7
  cp -r centos7/* /var/lib/tftpboot/centos7
  echo "拷贝pxelinux.0,splash.png,vesamenu.c32等配置文件"
  cp pxelinux.0 splash.png vesamenu.c32 /var/lib/tftpboot/
  sleep 2
  echo "将default配置文件拷贝到指定位置"
  mkdir /var/lib/tftpboot/pxelinux.cfg
  cp pxelinux.cfg/default  /var/lib/tftpboot/pxelinux.cfg
  sleep 2
  echo "启动并开机自启tftp"
  systemctl restart tftp > /dev/null
  systemctl enable tftp > /dev/null
}
ftpI(){
  echo "将应答文件(ks.cfg) 拷贝到ftp服务器上"
  sleep 2
  scp ks.cfg 192.168.4.254:/var/ftp/
  sleep 2
}
funishI(){
  echo "正在做清尾工作"
  rm -rf /pxe/*
  echo "PXE平台搭建完成，您可以使用了！"
}

nopass
dhcpI
tftpI
ftpI
funishI
