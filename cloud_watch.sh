#!/bin/bash
# TaoPlay 130 cloud watch loop: dispatch next run when previous completes; log results
export GH_TOKEN=$(cat /root/workspace/.secrets/github_pat)
REPO=T13424343468/taoplay-ci-tmp-130
LOG=/root/workspace/tmp-sim/taoplay-ci-130/cloud_watch.log
echo "$(date '+%F %T') watcher start" >> $LOG
while true; do
  RID=$(gh run list --repo $REPO --limit 1 --json databaseId --jq '.[0].databaseId' 2>>$LOG)
  ST=$(gh run list --repo $REPO --limit 1 --json status --jq '.[0].status' 2>>$LOG)
  if [ "$ST" = "completed" ]; then
    CONC=$(gh run view "$RID" --repo $REPO --json conclusion --jq .conclusion 2>>$LOG)
    echo "$(date '+%F %T') run $RID finished: $CONC" >> $LOG
    sleep 20
    OUT=$(gh workflow run emulator-matrix-test --repo $REPO -R $REPO 2>>$LOG)
    echo "$(date '+%F %T') dispatched: $OUT" >> $LOG
  fi
  sleep 60
done
