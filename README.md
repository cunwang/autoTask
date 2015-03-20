# AutoTask （Shell Script）
### 欢迎使用自动任务队列系统！


**@功能介绍：**Shell + 堵塞管道的原理可以实现：多任务、多进程、无人值守自动执行。

**@email** 1541231755@qq.com

**@date** 2015/03/16 - 03/20

**@version** 2.2

比如：同时有两个需要批量重置数据库内容的任务
1）更新新闻表每条记录的缩略图
2）更新评论表的所有用户的用户信息

面临的问题是：
 - 库很庞大，大概500W条记录
 - 查询时不能查太多，否则会锁表

正常解决方法是我们需要在cli 终端下分批次执行，很麻烦。用此脚本我们配置好文件后，可以实现自动化执行。

<br>
##Notice！


First Create the necessary folders:
- runtime
- pipe


1）run the script

$ /bin/bash main.sh

cat <<output

====================================
	Auto task System
====================================

Welcome to auto task, Please Choice a options:
 ------------------
 a) kill all the running script
 b) direct run the task list
 c) kill all script and run

output

2) Structure is introduced

	- main.sh   main
	- task.sh
	- pub_func  folder, global public function and variable
	- config    task config
	- runtime	folder, save the run log and error log
	- task		folder, task list
	- pipe		folder, pipe list
	- README.txt

