#!/bin/bash

# Use this script to push generated xml to remote manifest repo ,
# and then repo init and sync local repos
# Noted : You must offer a remote empty git repo address!
# Author : wendy
# Date : 2018/05/07

#remote manifest address: wendi@192.168.1.101:/home/wendi/test/manifest.git
networkCheck()
{
	#超时时间
	timeout=5
	
	#目标网站
	target=www.baidu.com

	#获取响应状态码
	ret_code=`curl -I -s --connect-timeout $timeout $target -w %{http_code} | tail -n1`

	if [ "x$ret_code" = "x200" ]; then
	#网络畅通
		echo "response code of baidu: " $ret_code
	else
	#网络不畅通
		echo "Net work status bad! Check your network connection before using this script!"
		exit -1
	fi
}

read_push_init(){
	read -p "Enter your remote empty repository for manifest file >>>" manifest_remote_address
	if [[ !-n$manifest_remote_address ]]; then
		#statements
		if git clone $manifest_remote_address; then

			file_name=$(echo $(basename $manifest_remote_address))
			mani_repo=$(echo $file_name | sed 's/\.[^.]*$//')
			source ./maniGen.sh
			cd $mani_repo
			cp ../default.xml .
			git add .
			git commit -m "add defalut xml config file"
			git push origin master

			# #use repo to init and sync
			cd ../
			read -p "Enter your dir name for repo init >>>" your_dir_name
			mkdir $your_dir_name
			cd $your_dir_name
			repo init -u $manifest_remote_address
			repo sync
			#and do what u want of all sub repo that you have permission!

		fi
		cd ../

	fi
}

#uncomment this for original use
# networkCheck
read_push_init