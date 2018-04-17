#usage : 
#. sub.sh init subdir_path remote_addr(确实改变目录位置)
#./sub.sh pull subdir_path（不改变目录位置）
#./sub.sh push subdir_path（不改变目录位置）
this_repo_path=$PWD
subdir_path=$2
cd $subdir_path
subdir_name=${PWD##*/}

if [[ $1 = 'init' ]]; then 
	#statements
	this_repo_name=${PWD##*/}
	remote_addr=$3
	#outside of current dir
	cd $this_repo_path
	cd ../
	#make local bare for it
	mkdir $subdir_name
	cd $subdir_name
	git init --bare
	#back to main and split the sub directory
	cd $this_repo_path
	git subtree split --prefix=$subdir_path -b split
	#push new branch to loacal share dir
	git push ../$subdir_name split:master
	# go to shared repo and push commit
	git remote add origin $remote_addr
	git push origin master
	#Delete the entire directory you split from, and then commit.
	cd $this_repo_path
	git rm -r $subdir_path
	git commit -am "Remove split code."
	#Add the new shared repository as a remote
	git remote add $subdir_name $remote_addr
	#add remote repo as a subtree
	git subtree add --prefix=$subdir_path --squash $subdir_name master
	echo "done!"
	#done!
elif [[ $1 = 'push' ]]; then 
	#statements
	cd $this_repo_path
	git subtree push --prefix=$subdir_path --squash $subdir_name master
elif [[ $1 = 'pull' ]]; then 
	#statements
	cd $this_repo_path
	git subtree pull --prefix=$subdir_path --squash $subdir_name master
fi






