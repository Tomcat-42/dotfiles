#!/bin/bash

export MONITOR1=`xrandr | grep VGA | sed -n 1p | awk '{print $1}'`
export MONITOR2=`xrandr | grep VGA | sed -n 2p | awk '{print $1}'`

