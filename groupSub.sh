#!/bin/bash

function print(){
   echo ">>>current in $PWD"
}
#place your remote address here
Server=(
"wendi@192.168.1.101:/home/wendi/test/server3/"
)


out_path=$PWD
#place your repo_name here
repo_name="myproj"
cd $repo_name
repo_path=$PWD


if [[ $1 = 'init' ]]; then
  for server in ${Server[@]}; do
	cd $out_path
	#make bare repository
	temp=$(echo $(basename ${server%/*}))
	mkdir $temp
	cd $temp
	subdir_path=Server/$temp
	git init --bare
	#split subtree and push to remote
	cd $repo_path
	git subtree split --prefix=$subdir_path -b split
	git push ../$temp split:master
	git remote add origin $server
	git push origin master
	
	cd $repo_path
	git rm -r $subdir_path
	git commit -am "Remove split code."
	
	git remote add $temp $server
  	git subtree add --prefix=$subdir_path --squash $temp master
  done
  #doing first commit
  git add .
  git commit -m "refreshing...and do commit"
  git push origin master
  cd ../
elif [[ $1 = 'push' ]]; then
	#push to all subdir remote
   git add --all
   git commit -m "all push"
   for server in ${Server[@]}; do
	  temp=$(echo $(basename ${server%/*}))
      subdir_path=Server/$temp  
      git subtree push --prefix=$subdir_path --squash $temp master
    done
	cd  ../
	echo "all push done!"
elif [[ $1 = 'pull' ]]; then
	#pull from all subdir then push to  master remote
  for server in ${Server[@]}; do
  	temp=$(echo $(basename ${server%/*}))
    subdir_path=Server/$temp
   	git subtree pull --prefix=$subdir_path --squash $temp master
  done
  git add .
  git commit -m "all pull"
  git push origin master
  cd ../
  echo "all pull done!"
elif [[ $1 = 'show' ]]; then
	git show
	cd ../
elif [[ $1 = 'status' ]]; then	
	git status
	cd ../
elif [[ $1 = 'log' ]]; then	
	git log
	cd ../
elif [[ $1 = 'reset' ]]; then	
	git reset $2
	cd ../
elif [[ $1 = 'merge' ]]; then
	#implements merge here
	git merge
	cd ../
fi