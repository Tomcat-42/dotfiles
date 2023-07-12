#!/bin/bash

# xset dpms force off & sleep 0.5 && slock
cat /home/pablo/.ssh/Banners/capy.txt | xargs -0 -I {} physlock -p "{}Artix Linux $(uname -r)"
