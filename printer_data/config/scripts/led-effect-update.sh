#!/bin/bash

cd ~
rm -rf klipper-led_effect
git clone https://github.com/julianschill/klipper-led_effect.git
cd klipper-led_effect
./install-led_effect.sh