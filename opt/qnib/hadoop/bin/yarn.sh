#!/bin/bash

set -xe

source /etc/bashrc.hadoop

function check_hdfs {
    cnt_hdfs=$(curl -s localhost:8500/v1/catalog/service/hdfs|grep -c "\"Node\":\"$(hostname)\"")
    if [ ${cnt_hdfs} -ne 1 ];then
        echo "[start_yarn] No running 'hdfs service yet, sleep 1sec'"
        sleep 1
        check_hdfs
    fi
}


trap "echo stopping yarn;su -c stop-yarn.sh hadoop; exit" HUP INT TERM EXIT

# Wait for hdfs to be up'n'running
check_hdfs

sleep 10

chown -R hadoop: ${YARN_LOG_DIR-/data/hadoopdata/logs/}/*

su -c 'start-yarn.sh' hadoop

set +x
while [ true ];do
    sleep 1
done
