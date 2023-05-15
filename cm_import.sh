#########################################################################
# File Name: cm_import.sh
# Author: haojian
# mail: hjwiki@gmail.com
# Created Time: 2023/3/6 14:43:27
# CM数据入库
# 爱立信4g路径：/data/output/cm/ericsson/4g/EricssonLteCm_20220731_09.csv 带表头
# 诺基亚4G路径：/data/output/cm/nokia/4g/nokiaCm_2023030303.csv
#########################################################################
#!/usr/bin/env bash

cd `dirname $0`
export PATH="$PATH:/usr/local/bin"
#shname=$(basename $0)
#logname=${shname%%.*}_$(date +"%Y%m%d").log
#log(){
#	t=$(date +"%Y-%m-%d %H:%M:%S")
#	echo $t --- $1 >> $logname
#	echo $t --- $1
#}


#sshpass -p "$password" ssh -t -oStrictHostKeyChecking=no "$username@ipaddress" 'command_one; command_two; command_three'
#导入爱立信4g
if [ $(ls /data/output/cm/ericsson/4g/EricssonLteCm_*.csv | wc -l) -gt 0 ];then
	for fname in /data/output/cm/ericsson/4g/EricssonLteCm_*.csv;do
		echo $(date +"%Y-%m-%d %H:%M:%S") 导入${fname}
		insertsql="\copy pm_parse.cm_4g from '${fname}' with (FORMAT csv, DELIMITER ',', HEADER true);"
		echo ${insertsql}
		psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "${insertsql}"
		if [ $? -eq 0 ];then
			mv ${fname} ${fname}.done
		else
			mv ${fname} ${fname}.err
		fi
	done
fi

#导入诺基亚4g
if [ $(ls /data/output/cm/nokia/4g/nokiaCm_*.csv | wc -l) -gt 0 ];then
	for fname in /data/output/cm/nokia/4g/nokiaCm_*.csv;do
		echo $(date +"%Y-%m-%d %H:%M:%S") 导入${fname}
		insertsql="\copy pm_parse.cm_4g from '${fname}' with (FORMAT csv, DELIMITER ',', HEADER true);"
		echo ${insertsql}
		psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "${insertsql}"
		if [ $? -eq 0 ];then
			mv ${fname} ${fname}.done
		else
			mv ${fname} ${fname}.err
		fi
	done
fi

#导入诺基亚电信4g
if [ $(ls /data/output/cm/nokia_ct/4g/nokiaCm_CT_*.csv | wc -l) -gt 0 ];then
	for fname in /data/output/cm/nokia_ct/4g/nokiaCm_CT_*.csv;do
		echo $(date +"%Y-%m-%d %H:%M:%S") 导入${fname}
		insertsql="\copy pm_parse.cm_4g from '${fname}' with (FORMAT csv, DELIMITER ',', HEADER true);"
		echo ${insertsql}
		psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "${insertsql}"
		if [ $? -eq 0 ];then
			mv ${fname} ${fname}.done
		else
			mv ${fname} ${fname}.err
		fi
	done
fi


#导入中兴4g
if [ $(ls /data/output/cm/zte/4g/ZTE_4g_cm_*.csv | wc -l) -gt 0 ];then
	for fname in /data/output/cm/zte/4g/ZTE_4g_cm_*.csv;do
		echo $(date +"%Y-%m-%d %H:%M:%S") 导入${fname}
		insertsql="\copy pm_parse.cm_4g from '${fname}' with (FORMAT csv, DELIMITER ',', HEADER true);"
		echo ${insertsql}
		psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "${insertsql}"
		if [ $? -eq 0 ];then
			mv ${fname} ${fname}.done
		else
			mv ${fname} ${fname}.err
		fi
	done
fi

#导入华为4g
if [ $(ls /data/output/cm/huawei/4g/huawei_4g_cm_*.csv | wc -l) -gt 0 ];then
	for fname in /data/output/cm/huawei/4g/huawei_4g_cm_*.csv;do
		echo $(date +"%Y-%m-%d %H:%M:%S") 导入${fname}
		awk 'BEGIN{FS=OFS=","}{if ($15 ~ /|/) $15=""}1' ${fname} >${fname}.awk
		insertsql="\copy pm_parse.cm_4g from '${fname}.awk' with (FORMAT csv, DELIMITER ',', HEADER true);"
		echo ${insertsql}
		psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "${insertsql}"
		if [ $? -eq 0 ];then
			mv ${fname} ${fname}.done
		else
			mv ${fname} ${fname}.err
		fi
	done
fi

psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -f cmupdate.sql

#导入爱立信5G
if [ $(ls /data/output/cm/ericsson/5g/ericssonNrCm_*.csv | wc -l) -gt 0 ];then
	for fname in /data/output/cm/ericsson/5g/ericssonNrCm_*.csv;do
		echo $(date +"%Y-%m-%d %H:%M:%S") 导入${fname}
		insertsql="\copy pm_parse.cm_5g from '${fname}' with (FORMAT csv, DELIMITER ',', HEADER true);"
		echo ${insertsql}
		psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "${insertsql}"
		if [ $? -eq 0 ];then
			mv ${fname} ${fname}.done
		else
			mv ${fname} ${fname}.err
		fi
	done
fi

#导入中兴5G
if [ $(ls /data/output/cm/zte/5g/ZTE_5g_cm_*.csv | wc -l) -gt 0 ];then
	for fname in ls /data/output/cm/zte/5g/ZTE_5g_cm_*.csv;do
		echo $(date +"%Y-%m-%d %H:%M:%S") 导入${fname}
		insertsql="\copy pm_parse.cm_5g from '${fname}' with (FORMAT csv, DELIMITER ',', HEADER true);"
		echo ${insertsql}
		psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "${insertsql}"
		if [ $? -eq 0 ];then
			mv ${fname} ${fname}.done
		else
			mv ${fname} ${fname}.err
		fi
	done
fi


#导入华为5g
if [ $(ls /data/output/cm/huawei/5g/huawei_5g_cm_*.csv | wc -l) -gt 0 ];then
	for fname in /data/output/cm/huawei/5g/huawei_5g_cm_*.csv;do
		echo $(date +"%Y-%m-%d %H:%M:%S") 导入${fname}
		awk 'BEGIN{FS=OFS=","}{if ($11 ~ /|/) $11=""}1' ${fname} >${fname}.awk
		insertsql="\copy pm_parse.cm_5g from '${fname}.awk' with (FORMAT csv, DELIMITER ',', HEADER true);"
		echo ${insertsql}
		psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "${insertsql}"
		if [ $? -eq 0 ];then
			mv ${fname} ${fname}.done
		else
			mv ${fname} ${fname}.err
		fi
	done
fi
