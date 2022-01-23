#!/bin/sh

adb shell screenrecord --output-format=h264 - | ffplay - 
