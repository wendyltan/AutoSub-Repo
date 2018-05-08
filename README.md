# AutoSubRepo
Shell scripts that help u manage sub repos under one single directory

## Requirement
有许多不同的子仓库。现在需要每个人可以管理自己有权限的子仓库。在一个大的git项目中，放置这些子仓库。仓库主人可以对大仓库以及这些子仓库进行git操作。

## Design
- 初始设计:基于单个文件的`sub.sh`
- 随后设计：基于多个子仓库信息的`groupSub`，这一版比较接近但是远弱于`Repo`工具许多
- 最新设计：使用高度封装的repo工具进行管理。但是repo工具需要远程库一个manifest库存储各个子库的配置信息xml。因此编写自动生成repo所需xml的脚本`maniGen.sh`和`repoSub.sh`，后者运用前者创建远端manifest库并且做根据配置文件xml做一些repo的初始化和同步操作


## Contents
- `sub.sh` 将已有的一个目录分成子项目。但是每次仅能作用于一个项目中已经存在的有内容的目录。
- `groupSub.sh` 
将一组固定地址的子项目合并到一个空的大项目中。随后可以统一pull或者push，后续将加入必要的git操作。但是需要事先将远程子库地址和大项目文件夹名字写在脚本中。~~后期如有需要将考虑使用配置文件~~
- `repoSub.sh`依赖`maniGen.sh`生成配置文件，用于配置远程配置库并且初始化repo库。
- `maniGen.sh`一个根据给定的`address.txt`中放置的子库地址，判断是否具有权限并且自动生成有权限子库信息xml的一个脚本

## Usage
+ sub.sh
    + `init`进行初始化，包括目录分配为子仓库（或者新建目录），添加远程子库，同步远程子库，删除原文件夹并用远程子库代替。
    + `pull`拉取远程的子库内容更新大项目内容。然后更新此大项目的远程内容
    + `push`将此大项目的内容推送到子项目远程库。
+ groupSub.sh
    - 运行`groupSub.sh --help`查看帮助
+ repoSub.sh
    - 直接运行，但是需要与`maniGen`在同一目录下
+ maniGen.sh
    - 直接运行，但记得放置一个address.txt到同样的目录下

## Noted
- 使用的测试环境均为内部主机。但是理论上换地址为git地址应该没有任何区别。
- repo库已经被墙。测试时候只是在**172**上安装过repo。安装可以尝试
> curl "http://php.webtutor.pl/en/wp-content/uploads/2011/09/repo" > repo  
chmod a+x repo  

- 如果每次init太慢，建议换源`REPO_URL = 'https://aosp.tuna.tsinghua.edu.cn/git-repo'`直接去repo文件目录修改repo代码。


