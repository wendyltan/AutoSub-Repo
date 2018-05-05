# AutoSubtree
Shell scripts that help u auto subtree a directory as a sub repository using git subtree

## Requirement
有许多不同的子仓库。现在需要每个人可以管理自己有权限的子仓库。在一个大的git项目中，放置这些子仓库。仓库主人可以对大仓库以及这些子仓库进行git操作。

## Design
- 初始设计:基于单个文件的`sub.sh`
- 随后设计：基于多个子仓库信息的`groupSub`，这一版比较接近但是远弱于`Repo`工具许多
- 最新设计：使用高度封装的repo工具进行管理。但是repo工具需要远程库一个manifest库存储各个子库的配置信息xml。因此编写自动生成repo所需xml的脚本`maniGen.sh`

## Contents
- `sub.sh` 将已有的一个目录分成子项目。但是每次仅能作用于一个项目中已经存在的有内容的目录。
- `groupSub.sh` 
将一组固定地址的子项目合并到一个空的大项目中。随后可以统一pull或者push，后续将加入必要的git操作。但是需要事先将远程子库地址和大项目文件夹名字写在脚本中。~~后期如有需要将考虑使用配置文件~~
- `maniGen.sh`一个根据给定的`address.txt`中放置的子库地址，判断是否具有权限并且自动生成有权限子库信息xml的一个脚本

## Usage
+ sub.sh
    + `init`进行初始化，包括目录分配为子仓库（或者新建目录），添加远程子库，同步远程子库，删除原文件夹并用远程子库代替。
    + `pull`拉取远程的子库内容更新大项目内容。然后更新此大项目的远程内容
    + `push`将此大项目的内容推送到子项目远程库。
+ groupSub.sh
    - 运行`groupSub.sh --help`查看帮助
+ maniGen.sh
    - 直接运行，但记得放置一个address.txt到同样的目录下

## Noted
- 对于`sub.sh`可以加载之前的配置文件`path.txt`，里面包含仓库名，子目录路径，子目录名和当前脚本根目录。如果配置文件不存在，会重新创建
- 现在`groupSub`还不能实现**merge**功能
- 在windows git bash环境下测试通过
- 由于在windows环境下编写的shell脚本在linux环境下会报错，请复制本脚本内容然后在linux下新建一个一样的文件。

