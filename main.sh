#!/bin/bash
# ---------------------------------- ------------- +
# file: main.sh 自动任务队列脚本入口
# ------------------------------------------------ +
# @todo 用于无人值守跑脚本
# @abstract 支持配置多任务、多进程、日志记录、Kill
# @author CMS.wangcun 
# @mail 1541231755@qq.com
# @date	2015/03/16 - 03/20
# @version 2.2 
# @useage : /bin/bash main.sh
# ------------------------------------------------ +
. ./pub_func
function help ()
{
clear
echo  -e "\n====================================\n\
	Auto task System\n\
====================================\n\
\nWelcome to auto task, Please Choice a options:\n \
------------------\n \
a) kill all the running script\n \
b) direct run the task list\n \
c) kill all script and run\
\n\n ";
}
function choice ()
{
	help
	read -p "Please Choice:" -n 1 Choice;
	case "$Choice" in
		a)
			killAll;
		;;
		b)
			monitor;	
		;;
		c)
			killAll;
			[ $? -eq 0 ] && monitor;
		;;
	esac
}

function monitor ()
{
	throw "\n[log] load config!";
	read_config
	local is_view;
	local task_name;
	local parse_data;
	local view_str='';
	local counter=0;
	[ -e $CONFIG_NAME -a $HANDLE_FLAG -eq 0 ] && throw '[log] loaded and start to parse config!' || iexit;

	cat $CONFIG_NAME | while read line
	do
		[ ! -n "${line}" ] && continue;
		[[ `echo "${line}" | grep "#"`  ]] && continue;
		[[ `echo "${line}" | grep "//"` ]] && continue;
		[[ `echo "${line}" | grep "/\*"` ]] && continue;

		task_name=`echo $line	| awk -F "|" '{print $1}'`;
		is_view=`echo $line		| awk -F "|" '{print $2}'`;
		[ $is_view -eq 0 ] && continue;
		
		#check is more than the biggest task queue, more will be ignore
		((counter++))
	   	if [ $counter -gt $TASK_MAX_NUM ]; then
			view_str="[err-log] More than the biggeset task queue (${TASK_MAX_NUM}) And Current Task (${task_name})  will be ignore!";
			throw "$view_str";
			log_it "$view_str";
			continue;
		fi

		#run task
		parse_data=$(parse_config "${CONFIG_TASK_PATH}${task_name}" "${task_name}");
		run_task "${parse_data}" "${task_name}";
	done;
	#unset $is_view; unset $task_name; unset $parse_data;
}

function read_config()
{
	if [ ! -e $CONFIG_NAME ]; then
		throw "error: the task's config is not exists! please Check!" && iexit;
	else
		HANDLE_FLAG=0;
	fi
}

function parse_config ()
{
	[ ! -e $1 ] && return;
	local task_more;
	local task_name;
    task_more=$1;
	task_name="$2";
    script_type=`cat ${task_more} 	| awk '$0 ~/itype/ {print $0}' 	| awk -F "=" '{print $2}'`;
    script_path=`cat ${task_more} 	| awk '$0 ~/ipath/ {print $0}' 	| awk -F "=" '{print $2}'`;
    script_start=`cat ${task_more}	| awk '$0 ~/istart/ {print $0}' | awk -F "=" '{print $2}'`;
    script_end=`cat ${task_more}	| awk '$0 ~/iend/ {print $0}' 	| awk -F "=" '{print $2}'`;
    script_step=`cat ${task_more} 	| awk '$0 ~/istep/ {print $0}' 	| awk -F "=" '{print $2}'`;
    script_thread=`cat ${task_more} | awk '$0 ~/ithread/ {print $0}'| awk -F "=" '{print $2}'`;
    throw "$(getInterpreter ${script_type})|${script_path}|${script_start}|${script_end}|${script_step}|${script_thread}";
}


function run_task ()
{
	local taskPipeName;
	throw "[log] run task: ${1}";
	log_it "/bin/bash ${CONFIG_CORE_SCRIPT} ${1} ${2} ${taskPipeName}\n";
	taskPipeName=$(getPipeByTask "$2");
	{
		echo "${2}"	> ${taskPipeName};
	} &

	{	
		/bin/bash ${CONFIG_CORE_SCRIPT} "${1}" "${2}" "${taskPipeName}"
		iexit
	} &
}
function main()
{
	choice;
}

trap 'debug $LINENO' ERR
trap 'debug $LINENO' EXIT
main
