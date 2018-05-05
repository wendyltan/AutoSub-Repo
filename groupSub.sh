#!/bin/bash

function print(){
   echo ">>>current in $PWD"
}


#place your remote address here
Server=(
"wendi@192.168.1.101:/home/wendi/test/server1/.git"
"wendi@192.168.1.101:/home/wendi/test/server2/.git"
"wendi@192.168.1.101:/home/wendi/test/server3/"
)


out_path=$PWD
#place your repo_name here
repo_name="myproj"
cd $repo_name
repo_path=$PWD


if [[ $1 = 'init' ]]; then
  mkdir "Server"
  for server in ${Server[@]}; do
	cd $out_path
	#make bare repository
	temp=$(echo $(basename ${server%/*}))
	mkdir "dircp"
	mkdir dircp/$temp
	cd dircp/$temp
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
    git add --all
	git commit -m "all push"
	if [[ $2 = 'subrepo' ]]; then
		# push and update subrepo 
		for server in ${Server[@]}; do
		  temp=$(echo $(basename ${server%/*}))
		  subdir_path=Server/$temp  
		  git subtree push --prefix=$subdir_path --squash $temp master
	   done
	else
		# push ifself!
		git push origin master
	fi
	cd  ../
	echo "push done!"
elif [[ $1 = 'pull' ]]; then
	if [[ $2 = 'subrepo' ]];then
		# pull from sub repos	
		for server in ${Server[@]}; do
		temp=$(echo $(basename ${server%/*}))
		subdir_path=Server/$temp
		git subtree pull --prefix=$subdir_path --squash $temp master
		done
	else
		#pull itself
		git pull
	fi
	cd ../
	echo "all pull done!"
elif [[ $1 = 'checkout' ]]; then
	if [[ $2 == -* ]]; then
		case $2 in
		-b)
			git checkout -b $3
			;;
		-f)
			git checkout -f $3
			;;
		-m)
			git checkout -m $3
			;;
		esac
	else
		git checkout $2
	fi
	
	cd ../
elif [[ $1 = 'status' ]]; then
	
	if [[ $2 = '-s' ]]; then
		git status -s
	else
		git status
	fi
	cd ../
elif [[ $1 = 'diff' ]]; then
	if [[ "$3" != "" ]]; then
		git diff $2 $3
	else
		case $2 in
		--cached)
			git diff --cached
			;;
		HEAD)
			git diff HEAD
			;;
		esac
	fi
	cd ../
elif [[ $1 = 'reset' ]]; then
	git log
	# $3 represent commit id
	if [[ $2 == 'HEAD' ]]; then
		git reset HEAD
	elif [[ $2 == 'soft' ]]; then
		git reset --soft $3
	elif [[ $2 == 'hard' ]]; then
		git reset --hard $3
	fi
	cd ../
elif [[ $1 = 'clone' ]]; then
	# $2 represent remote repository address
	git clone $2
	cd ../
elif [[ $1 = 'commit' ]]; then
	# $2 is option and $3 is commit message
	case $2 in
	-a)
		git commit -a
		;;
	--amend)
		git commit --amend 
		;;
	-m)
		git commit -m $3
		;;
	esac
	cd ../
elif [[ $1 = 'branch' ]]; then
	if [[ !$2 == -*  ]]; then
		# create a new branch but do not switch to it.
		git branch $2
		echo "create branch " $2
		
	elif [[ $2 == -* ]]; then
		case $2 in
		-r)
			git branch -r
			;;
		-a)
			git branch -a
			;;
		-d)
			# branch name that you want to delete
			git branch -d $3
			;;
		-D)
			git branch -D $3
			;;
		-vv)
			git branch -vv
			;;
		-m)
			# old branch name rename to new branch name
			git branch -m $3 $4
			;;
		esac
	else
		git branch
	
	fi
	cd ../
elif [[ $1 = 'merge' ]]; then
	# $2 represemt branch 1 name that you want to merge
	branch=$2
	options=$3
	if [ "$branch" != "" ];then
		if [ "$options" != "" ]; then
			case $options in
			--abort)
				git merge $branch --abort
				;;
			--commit|-nocommit)
				if [[ $options == '--commit' ]];then
					git merge $branch --commit 
				else
					git merge $branch --no-commit
				fi
				;;
			-e|--edit|--no-edit)
				if [[ $options == '--edit'||'-e' ]];then
					git merge $branch --edit
				else
					git merge $branch --no-edit
				fi
				;;
			-squash|--no-squash)
				if [[ $options == '--squash' ]];then
					git merge $branch --squash
				else
					git merge $branch --no-squash
				fi
				;;
			esac
		else
			echo "Please offer option"
		fi
	else
		echo "Please enter the branch you want to merge!" 
	fi
	cd ../
elif [[ $1 = 'stash' ]]; then
	if [[ $2 != "" ]] ;then
		case $2 in 
		pop|apply)
			if [[ $2 == "pop" ]] ;then
				git stash pop
			else
				# $3 represent stash here
				git stash apply $3
			fi
			;;
		list)
			git stash list
			;;
		clear)
			git stash clear
			;;
		save)
			# $3 represent message 
			git stash save $3
			;;
		esac
	
	else
		git stash
	fi
	cd ../
elif [[ $1 = "show" ]]; then
	git show
	cd ../
elif [[ $1 = "--help" ]]; then
	echo "    init        init repository using given series of repositories' address"
	echo "    push        push repository to remote or push changes to remote sub repos"
	echo "    pull        pull changes from remote or pull changes from remote sub repos"
	echo "    checkout    basic implementation of git checkout"
	echo "    status      basic implementation of git status"
	echo "    diff        basic implementation of git diff"
	echo "    reset       basic implementation of git reset"
	echo "    clone       basic implementation of git clone"
	echo "    commit      basic implementation of git commit"
	echo "    merge       basic implementation of git merge"
	echo "    branch      basic implementation of git branch"
	echo "    stash       basic implementation of git stash"
	echo "    show        basic implementation of git show"
	cd ../
fi