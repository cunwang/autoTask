#!/bin/bash
# ---------------------------------- ------------- +
# file: task.sh 任务核心脚本
# ------------------------------------------------ +
# @todo 接收任务，执行任务
# @abstract 核心脚本
# @author CMS.wangcun 
# @mail 1541231755@qq.com
# @date	2015/03/16 - 03/20
# @version 2.2 
# ------------------------------------------------ +

TaskName=$2
TaskPipe=$3
TaskMoreInfo=$1

function parseParam()
{
	script_type=`echo ${TaskMoreInfo} | awk -F "|" '{print $1}'`;
	script_path=`echo ${TaskMoreInfo} | awk -F "|" '{print $2}'`;
	script_start=`echo ${TaskMoreInfo} | awk -F "|" '{print $3}'`;
	script_end=`echo ${TaskMoreInfo} | awk -F "|" '{print $4}'`;
	script_step=`echo ${TaskMoreInfo} | awk -F "|" '{print $5}'`;
	script_thread=`echo ${TaskMoreInfo} | awk -F "|" '{print $6}'`;
}
. ./pub_func
trap 'debug $LINENO' ERR
#free pipe
cat $TaskPipe 

[ $# -ne 3 ] && throwANDexit "pararm is error!";

#parse arguments
throw "[core-log] ${TaskName}\t${TaskPipe}\t${TaskMoreInfo}\n";
parseParam

# Check the max task thread
SEND_THREAD_NUM=${script_thread};
echo $SEND_THREAD_NUM;
if [ ${SEND_THREAD_NUM} -gt ${TASK_MAX_THREAD} ]; then
	log_it "[err-log] The current Task (${TaskName}) set more than the maximum value of thread! system will use the default! ";
	SEND_THREAD_NUM=${TASK_MAX_THREAD};
fi

tmp_fifofile=$TaskPipe;
[ ! -e "$tmp_fifofile" ] && throwANDexit "pipe not found!";
exec 6<>"$tmp_fifofile"

for ((i=0; i<$SEND_THREAD_NUM; i++));do
  echo                                                                                    
done >&6 

START=${script_start};
STEP=${script_step};
LIMIT=${script_step}
_MAX=${script_end};
S=0;
NEXT=0;
SCRIPT_BIN=${script_type};

while true;
do
	let S=$START;
	((NEXT=S + STEP));
	[ "${S}" -gt "${_MAX}" ] && exit -1;
	read -u6 
	{
		echo -e "The Nums is :${S}  ${NEXT}\t";
		${SCRIPT_BIN} ${script_path} ${S} ${LIMIT} ${TaskPipe}
	} &
	((START=NEXT));
done
wait
exec 6>&-
