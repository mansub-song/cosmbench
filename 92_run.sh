#!/bin/bash
source ./env.sh
source ./run_env.sh

INDEX=$1
CURRENT_DATA_DIR=$TESTDIR/node$INDEX
echo "$BINARY start --home $CURRENT_DATA_DIR"
# $BINARY start --home $CURRENT_DATA_DIR


rm -f logs/output$INDEX.log

# # committed state라는 문장이 들어있는 문장에 Unix millisecond timestamp 출력
# $BINARY start --home $CURRENT_DATA_DIR 2>&1 | while IFS= read -r line; do
#   if [[ "$line" == *"committed state"* ]]; then
#     echo "$(date '+%s%3N') $line"
#   fi
# done >> logs/output$INDEX.log



# Start the binary and filter lines containing "committed state"
$BINARY start --home "$CURRENT_DATA_DIR" 2>&1 | while IFS= read -r line; do
  if [[ "$line" == *"committed state"* ]]; then
    # ANSI 이스케이프 코드 제거
    clean_line=$(echo "$line" | sed -r "s/\x1B\[[0-9;]*[mK]//g")
    
    # Unix millisecond 타임스탬프 추가
    timestamped_line="$(date '+%s%3N') $clean_line"
    
    # 로그 파일에 기록 및 화면에 출력
    echo "$timestamped_line" | tee -a "logs/output$INDEX.log"
  fi
done