#!/bin/bash
# �Զ�ֹͣ Klipper -> ˢд�̼� -> ���� Klipper

DEVICE="/dev/ttyS0"            # �����豸��������Ҫ�޸�
BAUD=250000                    # ������
FIRMWARE="~/klipper/out/klipper.bin"   # �̼�·����������Ҫ�޸�
FLASHTOOL="/home/klipper/katapult/scripts/flashtool.py"

echo "=== ֹͣ Klipper ���� ==="
sudo systemctl stop klipper

echo "=== ��ʼ�������� ==="
python3 $FLASHTOOL -d $DEVICE -b $BAUD -f $FIRMWARE -r

echo "=== ��ʼˢд�̼� ==="
python3 $FLASHTOOL -d $DEVICE -b $BAUD -f $FIRMWARE
FLASH_RET=$?

if [ $FLASH_RET -eq 0 ]; then
    echo "=== ˢд�ɹ������� Klipper ���� ==="
    sudo systemctl start klipper
    echo "��� ?"
else
    echo "ˢдʧ�� ?������ flashtool.py �����־"
    echo "Klipper �����Զ����������ֶ�����"
fi
