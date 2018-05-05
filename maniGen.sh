#!/bin/bash

# Generate basic manifest xml file for repo remote manifest repository
# Noted : You must offer a address txt file with each line a git repository address written in it
# Author : wendy
# Date : 2018/05/05

outfile=default.xml
tabs=0
#clear the file everytime rerun this script
cat /dev/null > 'default.xml'

array_index=0
path=""

put(){
	echo -e '<'${*}'>' >> $outfile
}

put_head(){
	put '?'${1}'?'
}

out_tabs(){
	tmp=0
	tabsstr=""
	while [ $tmp -lt $((tabs)) ]
	do
		tabsstr=${tabsstr}'\t'
		tmp=$((tmp+1))
	done
	echo -e -n $tabsstr >> $outfile

}

tag_start(){
	out_tabs
	put $1
	tabs=$((tabs+1))
}

tag_end(){
	tabs=$((tabs-1))
	out_tabs
	put '/'${1}
}


tag_remote(){
	out_tabs
	str=""
	str='remote name="'${1}'"\n\t\t\t
		        fetch="'${2}'"/'
	put $str
}

tag_default(){
	out_tabs
	str=""
	str='default revision="'${1}'"\n\t\t\t
			     remote="'${2}'"/'
    put $str
}
tag_project(){
	out_tabs
	str=""
	str='project path="'${1}'"\n\t\t\t
			     name="'${2}'"/'
    put $str
}

check_can_clone(){
	# uncomment here when internet is usable!
	# if ! git clone ${1};then
	#     echo >&2 "error: you don't have permission on this repository!skipping..."
	# else
	# 	write_info ${1}
	# fi
	write_info ${1}
}

read_address(){
	if [ ! -f "address.txt" ]; then 
		 echo "address.txt doesn't exist!check your path..."
		 exit -1
	else
		for line in $(cat address.txt)
		do 
			echo "read address :${line}"
			#检查这个仓库是否可以clone（是否有权限）
			check_can_clone ${line}
		done
	fi 
	
}

write_info(){
	line=${1}
	#对地址处理，最后的是仓库名，将仓库名和前缀分离。
	fullsuffix=$(echo $(basename ${1}))
	path=$(echo $(dirname ${1}))
	#这是仓库名
	filename=$(echo $fullsuffix | sed 's/\.[^.]*$//')
	#保存进数组用于稍后生成xml节点信息
	arr[$array_index]=$filename
	array_index=`expr $array_index + 1` 
}

gen_XML(){
	put_head 'xml version="1.0" encoding="UTF-8"'
	tag_start 'manifest'
	#default can only have one!
	tag_default master github
	tag_remote github $path
	for address in ${arr[@]}; do
		tag_project repos/$address $address
	done
	tag_end 'manifest'
	echo "manifest file generate success!"
}


read_address
gen_XML 
echo '-----------------generated xml file content:--------------'
echo `cat default.xml`
echo '---------------------------end:---------------------------'