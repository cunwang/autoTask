Auto task是一个自动化的Shell脚本，工作原理就是利用堵塞管道实现多任务同时处理。

###功能介绍

    - 支持多任务
    - 可配置运行间歇
    - 支持多种类型脚本，目前仅支持Shell 和PHP
    - 无人值守


<br>
###目录结构

	- main.sh   main
	- task.sh
	- pub_func  folder, global public function and variable
	- config    task config
	- runtime	folder, save the run log and error log
	- task		folder, task list
	- pipe		folder, pipe list
	- README.txt

<br>
###配置文件介绍

``$ cat ./task/comment``

    #[Script Type]<br>
     itype=php

    #[program absloute path]
    ipath=/export/home/www/testProject/2.php

    #[start record]
    istart=0

    #[end record]
    iend=500000

    #[step]
    istep=1000

    #[run thread]
    ithread=3



<br>
###[如何使用]

####1、创建需要的文件夹
    - runtime
    - pipe


####2、运行脚本

``$ /bin/bash main.sh``

    =============================================
    Auto task System
    =============================================
    Welcome to auto task, Please Choice a options:
    ---------------------------------------------
    a) kill all the running script
    b) direct run the task list
    c) kill all script and run



<br>
####3、运行效果
`` The Nums is :14000  15000``<br>
``The Nums is :15000  16000 ``

    SELECT id FROM news WHERE status=1 AND content!='' AND (`id` > 14000 AND `id` < 1000) ORDER BY id ASC
    SELECT id FROM news_info WHERE status=1 AND content!='' AND (`id` > 15000 AND `id` < 1000) ORDER BY id ASC<br><br>


``The Nums is :140000  150000``<br>
``The Nums is :150000  160000``

    SELECT id FROM comment WHERE status=1 AND content!='' AND (`id` > 140000 AND `id` < 10000) ORDER BY id ASC
    SELECT id FROM comment WHERE status=1 AND content!='' AND (`id` > 150000 AND `id` < 10000) ORDER BY id ASC
    ......

Over！
