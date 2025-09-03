#!/bin/bash

cd ~
rm -rf klipper-backup
curl -fsSL get.klipperbackup.xyz | bash
~/klipper-backup/install.sh