# AutoSubtree
A shell script that help u auto subtree a directory as a sub repository using git subtree

## Usage
`. sub.sh init`进行初始化，包括目录分配为子仓库，添加远程子库，同步远程子库，删除原文件夹并用远程子库代替。
`. sub.sh pull`拉取远程的子库内容更新大项目内容。然后更新此大项目的远程内容
`. sub.sh push`将此大项目的内容推送到子项目远程库。

## Noted
- 可以加载之前的配置文件`path.txt`。里面包含仓库名，子目录路径，子目录名和当前脚本根目录。如果配置文件不存在，会重新创建
- 在windows git bash环境下测试通过
