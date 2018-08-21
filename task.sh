#!/bin/bash
# ------------------------------------------------ +
# file: task.sh 
# ------------------------------------------------ +
# @abstract core
# @author <github.com/cunwang>
# @date	2015/03/16 - 03/20
# @edit date	2018/08/17
# @version 1.2
# ------------------------------------------------ +

TaskName=$2
TaskPipe=$3
TaskMoreInfo=$1

:<<!
[Function] Parse params and assignment.
!
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

cat $TaskPipe #Release pipe datas
[ $# -ne 3 ] && throwANDexit "pararm is error!";
throw "[core-log] ${TaskName}\t${TaskPipe}\t${TaskMoreInfo}\n";

parseParam

START=${script_start};
STEP=${script_step};
LIMIT=${script_step}
_MAX=${script_end};
S=0;
NEXT=0;
SCRIPT_BIN=${script_type};

step_model_valid

:<<!
If amount of task  thread bigger than system configed（$TASK_MAX_THREAD）, 
default reset as system thread nums.
!
SEND_THREAD_NUM=${script_thread};
if [ ${SEND_THREAD_NUM} -gt ${TASK_MAX_THREAD} ]; then
	SEND_THREAD_NUM=${TASK_MAX_THREAD};
	log_it "[err-log] The current Task (${TaskName}) set more than the maximum value of thread! system will use the default! ";
fi

echo ${SORT_MODEL}
#iexit
tmp_fifofile=$TaskPipe;
[ ! -e "$tmp_fifofile" ] && throwANDexit "pipe not found!";
exec 6<>"$tmp_fifofile"

for ((i=0; i<$SEND_THREAD_NUM; i++));do
  echo                                                                                    
done >&6 

:<<!
Core function, Execute Task.
!
while true;
do
	let S=$START;
	if [ "${SORT_MODEL}" == "asc" ]; then
		((NEXT=S + STEP));
		[ "${S}" -gt "${_MAX}" ] && iexit;
	else
		((NEXT=S - STEP));
		[ "${S}" -lt "${_MAX}" ] && iexit;
	fi

	read -u6 
	{
		if [ $STEP_MODEL == "date" ]; then
			DAYS=`date -d @"${S}" "+$STEP_DATE_FORMAT"`;
			${SCRIPT_BIN} ${script_path} ${DAYS} ${TaskPipe}
		else
			echo "${SCRIPT_BIN} ${script_path} ${S} ${LIMIT} ${TaskPipe}";
			${SCRIPT_BIN} ${script_path} ${S} ${LIMIT} ${TaskPipe}
		fi
	} &
	((START=NEXT));
done
wait
exec 6>&-

echo "All job done!";
