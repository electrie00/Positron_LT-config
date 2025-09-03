#!/bin/bash
# 自动停止 Klipper -> 刷写固件 -> 重启 Klipper

DEVICE="/dev/ttyS0"            # 串口设备，根据需要修改
BAUD=250000                    # 波特率
FIRMWARE="~/klipper/out/klipper.bin"   # 固件路径，根据需要修改
FLASHTOOL="/home/klipper/katapult/scripts/flashtool.py"

echo "=== 停止 Klipper 服务 ==="
sudo systemctl stop klipper

echo "=== 开始请求引导 ==="
python3 $FLASHTOOL -d $DEVICE -b $BAUD -f $FIRMWARE -r

echo "=== 开始刷写固件 ==="
python3 $FLASHTOOL -d $DEVICE -b $BAUD -f $FIRMWARE
FLASH_RET=$?

if [ $FLASH_RET -eq 0 ]; then
    echo "=== 刷写成功，重启 Klipper 服务 ==="
    sudo systemctl start klipper
    echo "完成"
else
    echo "刷写失败 ?，请检查 flashtool.py 输出日志"
    echo "Klipper 不会自动启动，请手动处理"
fi

