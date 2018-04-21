#!/usr/bin/env bash
#usage :
#. sub.sh init 
#./sub.sh pull 
#./sub.sh push 
function config_init(){
	touch "path.txt" 
	#input for parameters
	current_path=$PWD
	read -p "Please enter the repo name:" this_repo_name
	read -p "Please enter the subdir you want to divide:" subdir_path
	cd $this_repo_name/$subdir_path
	subdir_name=${PWD##*/}
	#writing config into config file
	cd $current_path
	echo "writing config..."
	echo $this_repo_name >> path.txt
	echo $current_path >> path.txt
	echo $subdir_path >> path.txt
	echo $subdir_name >> path.txt
}

function load_config(){
	if [ ! -f "path.txt" ]; then 
	 	echo "No config file around!Create new one..."
	 	config_init
	else
		echo "reading old config file!"
		sys_info=$(cat path.txt)
		var=`echo   $sys_info   |   awk   -F ','   '{print   $0}'   |   sed   "s/,/   /g"`
		this_repo_name=$(echo $var | awk '{print $1}')
		current_path=$(echo $var | awk '{print $2}')
		subdir_path=$(echo $var | awk '{print $3}')
		subdir_name=$(echo $var | awk '{print $4}')
		cd $current_path
	fi
	
}


if [[ $1 = 'init' ]]; then 
	load_config
	#make local bare for it
	mkdir $subdir_name
	cd $subdir_name
	git init --bare
	#back to main and split the sub directory
	cd $current_path/$this_repo_name
	git subtree split --prefix=$subdir_path -b split
	#push new branch to loacal share dir
	git push ../$subdir_name split:master
	# go to shared repo and push commit
	read -p "Please enter remote repostory address for this subdir:" remote_addr
	git remote add origin $remote_addr
	git push origin master
	#Delete the entire directory you split from, and then commit.
	cd $current_path/$this_repo_name
	git rm -r $subdir_path
	git commit -am "Remove split code."
	#Add the new shared repository as a remote
	git remote add $subdir_name $remote_addr
	#add remote repo as a subtree
	git subtree add --prefix=$subdir_path --squash $subdir_name master
	cd $current_path
	echo "done!"
	#done!
elif [[ $1 = 'push' ]]; then
	#push to subdir remote
	load_config
	cd $this_repo_name
	git subtree push --prefix=$subdir_path --squash $subdir_name master
	cd $current_path
	echo "done!"
elif [[ $1 = 'pull' ]]; then
	#pull from subdir then push to remote
	load_config
	cd $this_repo_name
	git subtree pull --prefix=$subdir_path --squash $subdir_name master
	git push origin master
	cd $current_path
	echo "done!"
fi






