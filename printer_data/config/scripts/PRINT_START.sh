#!/bin/bash

LOG_FILE="$HOME/print_start_log.txt"

# 默认值
EXTRUDER_TEMP=0
BED_TEMP=0

for ARG in "$@"; do
  case $ARG in
    EXTRUDERTEMP=*)
      EXTRUDER_TEMP="${ARG#*=}"
      ;;
    BEDTEMP=*)
      BED_TEMP="${ARG#*=}"
      ;;
  esac
done

echo "$(date) EXTRUDER=$EXTRUDER_TEMP BED=$BED_TEMP" >> "$LOG_FILE"
echo "开始加热流程 EXTRUDER=$EXTRUDER_TEMP BED=$BED_TEMP" >> "$LOG_FILE"

# 构建 G-code 脚本内容
SCRIPT=$(cat <<EOF
M140 S$BED_TEMP
M104 S$EXTRUDER_TEMP
G28
M190 S$BED_TEMP
M109 S$EXTRUDER_TEMP
G92 E0
G1 X8 Y150 Z0.3 F7200
G1 X8 Y20 E12 F800
EOF
)

# 调用 Moonraker 接口执行 G-code 脚本
jq -n --arg script "$SCRIPT" '{script: $script}' | \
curl -s -X POST http://localhost:7125/printer/gcode/script \
  -H "Content-Type: application/json" \
  -d @- >> "$LOG_FILE" 2>&1

echo "打印前流程完成" >> "$LOG_FILE"