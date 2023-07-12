#!/usr/bin/env bash  

wal -n -R

source /home/pablo951_br/.cache/wal/colors.sh  

#termite
echo "[colors]
foreground=$foreground
background=$(python /home/pablo951_br/Downloads/scripts/hex2rgb.py $background)
color0=$color0
color1=$color1
color2=$color2
color3=$color3
color4=$color4
color5=$color5
color6=$color6
color7=$color7
color8=$color8
color9=$color9
color10=$color10
color11=$color11
color12=$color12
color13=$color13
color14=$color14
color15=$color15
" > /home/pablo951_br/.config/termite/config_cor
cat /home/pablo951_br/.config/termite/config_s_cor > /home/pablo951_br/.config/termite/config ; cat /home/pablo951_br/.config/termite/config_cor >> /home/pablo951_br/.config/termite/config

#tty
cp /home/pablo951_br/.cache/wal/colors-tty.sh /home/pablo951_br/Downloads/scripts/
chmod +x /home/pablo951_br/Downloads/scripts/colors-tty.sh

#setcolors
echo "0$color0
1$color1
2$color2
3$color3
4$color4
5$color5
6$color6
7$color7
8$color8
9$color9
10$color10
11$color11
12$color12
13$color13
14$color14
15$color15
" > /home/pablo951_br/.config/setcolors/config

#'color' mkinitcpio early hook
sudo cat /home/pablo951_br/.config/setcolors/config | sed 's/^\(.*\)#\(.\{6\}\).*$/COLOR_\1=\2/' > /home/pablo951_br/vconsole.cores

sudo cat /etc/vconsole.settings > /home/pablo951_br/vconsole.conf ; sudo cat /home/pablo951_br/vconsole.cores >> /home/pablo951_br/vconsole.conf ; sudo rm /etc/vconsole.conf ; sudo mv /home/pablo951_br/vconsole.conf /etc/  ; rm /home/pablo951_br/vconsole*
