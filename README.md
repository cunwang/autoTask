# autoTask
欢迎使用自动任务队列系统！

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

