# AutoSubtree
Shell scripts that help u auto subtree a directory as a sub repository using git subtree

## Contents
- `sub.sh` 将已有的一个目录分成子项目。但是每次仅能作用于一个项目中已经存在的有内容的目录。
- `groupSub.sh` 
将一组固定地址的子项目合并到一个空的大项目中。随后可以统一pull或者push，后续将加入必要的git操作。但是需要事先将远程子库地址和大项目文件夹名字写在脚本中。后期如有需要将考虑使用配置文件

## Usage
- `init`进行初始化，包括目录分配为子仓库（或者新建目录），添加远程子库，同步远程子库，删除原文件夹并用远程子库代替。
- `pull`拉取远程的子库内容更新大项目内容。然后更新此大项目的远程内容
- `push`将此大项目的内容推送到子项目远程库。

## Noted
- 对于`sub.sh`可以加载之前的配置文件`path.txt`，里面包含仓库名，子目录路径，子目录名和当前脚本根目录。如果配置文件不存在，会重新创建
- 现在`groupSub`还不能实现**merge**功能
- 在windows git bash环境下测试通过
- 由于在windows环境下编写的shell脚本在linux环境下会报错，请复制本脚本内容然后在linux下新建一个一样的文件。

