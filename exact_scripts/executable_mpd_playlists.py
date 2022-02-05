#!/usr/bin/env python

import os

def rock():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find Rock\ diversas/* -type f | sort -z > /mnt/PABLO/android_repo/HOME/Músicas/playlists/rock.m3u')

def dubstep():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find Eletronicas\ diversas/* -type f | sort -z > /mnt/PABLO/android_repo/HOME/Músicas/playlists/dubstep.m3u')

def outras():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find Outras/* -type f | sort -z > /mnt/PABLO/android_repo/HOME/Músicas/playlists/outras.m3u')

def limao():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find blonde\ redhead\ \-\ melody\ of\ certain\ damaged\ lemons/* -type f | sort -z >  /mnt/PABLO/android_repo/HOME/Músicas/playlists/melody_of_certain_damaged_lemon.m3u')

def moon():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find Pink\ floyd/1973\ \-\ The\ Dark\ Side\ Of\ The\ Moon/* -type f | sort -n > /mnt/PABLO/android_repo/HOME/Músicas/playlists/the_dark_side_of_the_moon.m3u')

def wish():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find Pink\ floyd/1975\ \-\ Wish\ You\ Were\ Here/* -type f | sort -n > /mnt/PABLO/android_repo/HOME/Músicas/playlists/wish_you_where_here.m3u')

def wall():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find Pink\ floyd/1979\ -\ The\ Wall/* -type f | sort -n > /mnt/PABLO/android_repo/HOME/Músicas/playlists/the_wall.m3u')

def animals():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find Pink\ floyd/1977\ -\ Animals/* -type f | sort -n > /mnt/PABLO/android_repo/HOME/Músicas/playlists/animals.m3u')
    
def classical():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find classical/* -type f | sort -z > /mnt/PABLO/android_repo/HOME/Músicas/playlists/classical.m3u')

def _all():
    os.system('cd /mnt/PABLO/android_repo/HOME/Músicas ; find Rock\ diversas/* Eletronicas\ diversas/* Pink\ floyd/1973\ \-\ The\ Dark\ Side\ Of\ The\ Moon/*  Pink\ floyd/1975\ \-\ Wish\ You\ Were\ Here/* Pink\ floyd/1979\ -\ The\ Wall/* Pink\ floyd/1977\ -\ Animals/* classical/* -type f | sort -n >  /mnt/PABLO/android_repo/HOME/Músicas/playlists/all.m3u') 



rock()
dubstep()
outras()
limao()
moon()
wish()
wall()
animals()
classical()
_all()
