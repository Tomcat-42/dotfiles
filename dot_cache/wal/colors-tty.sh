#!/bin/sh
[ "${TERM:-none}" = "linux" ] && \
    printf '%b' '\e]P0000000
                 \e]P1ff004d
                 \e]P200e756
                 \e]P3fff024
                 \e]P483769c
                 \e]P5ff77a8
                 \e]P629adff
                 \e]P7ffffff
                 \e]P8008751
                 \e]P9ff004d
                 \e]PA00e756
                 \e]PBfff024
                 \e]PC83769c
                 \e]PDff77a8
                 \e]PE29adff
                 \e]PFfff1e8
                 \ec'
