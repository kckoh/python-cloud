#!/bin/bash

. /etc/profile



##############################################################
# 1. Set Default Variables

HOST=$HOSTNAME

SHORT_DATE=`date '+%Y-%m-%d'`

TIME=`date '+%H%M'`


##############################################################
# Product Variables

PRODUCT_USERNAME=`whoami`

##############################################################
######### DO NOT MODIFY ABOVE THIS LINE ######################

# Setting up environment variables

filenametime1=$(date +"%m%d%Y%H%M%S")
filenametime2=$(date +"%Y-%m-%d %H:%M:%S")

export BASE_PATH="/home/weclouddata/linux"
export SCRIPTS_FOLDER="/home/ec2-user/wecloud"

export LOGDIR='/home/ec2-user/wecloud/log'


export SCRIPT='script'
export LOG_FILE=${LOGDIR}/${SCRIPT}_${filenametime1}.log
export PYTHON_LOG_FILE=${LOGDIR}/${SCRIPT}_python_${filenametime1}.log


cd ${SCRIPTS_FOLDER}

# exec 2> ${LOG_FILE} 1>&2
exec > >(tee ${LOG_FILE})
exec 2> >(tee ${LOG_FILE} >&2)

##############################################################
# Begin downloading the files
# echo "begin downlading the files"

# for year in {2020..2022}; 
# do wget -P ${DOCDIR}  --content-disposition "https://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=1706&Year=${year}&Month=2&Day=28&timeframe=1&submit= Download+Data" ;
# done;


##############################################################
# Begin PYTHON SCRIPT

# echo "[PROCESS]: STARTING RUN PYTHON SCRIPT '${SCRIPT}.py'.\n"
source venv/bin/activate
python3 ${SCRIPTS_FOLDER}/run.py
deactivate

RC1=$?
if [ ${RC1} != 0 ]; then
	echo "\n[ERROR:] ERROR FOR SCRIPT ${SCRIPT}.py"
	echo "[ERROR:] RETURN CODE:  ${RC1}"
	echo "[ERROR:] REFER TO THE LOG FOR THE REASON FOR THE FAILURE."
	echo "[ERROR:] LOG FILE NAME: "${PYTHON_LOG_FILE}
	exit 1
fi

echo "\n[SUCESS]:SCRIPT ${SCRIPT}.py RUNNING SUCCEDED"
echo "[PROCESS]: END SCRIPT RUNNING PROCESS"

# ##ENDING PROCESS
# echo "\n[JOB]: LOAD SESSION OF ${TASK_CLIENT} ${TASK_TASK} PROCESS COMPLETED SUCCESSFULLY."
# echo "[JOB]: ${TASK_CLIENT} ${TASK_TASK} PROCESS END AT $(date)"
echo -e "\nEND"

exit 0


