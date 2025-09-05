#!/bin/bash

LOG_FILE="$HOME/print_start_log.txt"

# Ĭ��ֵ
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
echo "��ʼ�������� EXTRUDER=$EXTRUDER_TEMP BED=$BED_TEMP" >> "$LOG_FILE"

# ���� G-code �ű�����
SCRIPT=$(cat <<EOF
M140 S$BED_TEMP
M104 S$EXTRUDER_TEMP
G28
M190 S$BED_TEMP
M109 S$EXTRUDER_TEMP
G92 E0

G1 X8 Y150 Z0.5 F7200
G1 E15 F800
G1 X8 Y20 E30 F500
G1 X10 Y150 E45 F500
EOF
)

# ���� Moonraker �ӿ�ִ�� G-code �ű�
jq -n --arg script "$SCRIPT" '{script: $script}' | \
curl -s -X POST http://localhost:7125/printer/gcode/script \
  -H "Content-Type: application/json" \
  -d @- >> "$LOG_FILE" 2>&1

echo "��ӡǰ�������" >> "$LOG_FILE"