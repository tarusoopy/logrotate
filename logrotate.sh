#!/bin/bash
#Log Rotation Script AM 0:00

# ログファイルが置かれているフォルダ
LOGDIR="/usr/local/nginx/logs"
# ログファイルを保管するフォルダ(今は同じフォルダに保管してる)
OLDLOGDIR="/usr/local/nginx/logs"
# ディレクトリのWrite権のあるユーザ
USER=openapi

# ジャーナルとエラーを対象
JOURNALLOG="journal.log"
ERRORLOG="error.log"

sleep 1

DATE=`date +%Y%m%d --date '1 day ago'`

sudo -u $USER /bin/cp ${LOGDIR}/${file} ${OLDLOGDIR}/${JOURNALLOG}.$DATE
JERR=$?
sudo -u $USER /bin/cp ${LOGDIR}/${file} ${OLDLOGDIR}/${ERRORLOG}.$DATE
EERR=$?

if [ $JERR = 0 ];then
    # 名前を変えたら新しいファイルを作って古いのを圧縮
    sudo -u $USER /bin/touch ${LOGDIR}/${JOURNALLOG}
    sudo -u $USER gzip ${LOGDIR}/${JOURNALLOG}.$DATE
fi
if [ $EERR = 0 ];then
    # 名前を変えたら新しいファイルを作って古いのを圧縮
    sudo -u $USER /bin/touch ${LOGDIR}/${ERRORLOG}
    sudo -u $USER gzip ${LOGDIR}/${ERRORLOG}.$DATE
fi

# delete log file before 7 days
# 削除対象が存在しない時のために --no-run-if-empty オプションを指定
/usr/bin/find ${OLDLOGDIR}/${JOURNALLOG}.* -mtime +6 | xargs --no-run-if-empty /bin/rm
/usr/bin/find ${OLDLOGDIR}/${ERRORLOG}.* -mtime +6 | xargs --no-run-if-empty /bin/rm

echo "finish rotate ${JOURNALLOG} ${ERRORLOG}"
