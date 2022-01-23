#!/usr/bin/env bash

mv ~/.calcurse/todo ~/.todo
calcurse-caldav
mv ~/.todo ~/.calcurse/todo
calcurse
