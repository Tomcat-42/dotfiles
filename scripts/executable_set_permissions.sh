#!/bin/bash

read -r -p "Correct file and folder permissions? [y/N] " chse
if [[ "$chse" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
  echo "Processing ..."
  find -H $(pwd) -type d -exec chmod 0755 {} \;
  # set dirs to 755
  find -H $(pwd) -type f \( -iname '*.so.*' -o -iname '*.so' \) -exec chmod 0644 {} \;
  # libs
  IFS=$'\n'
  for value in $(find -H $(pwd) -type f ! \( -iname '*.so.*' -o -iname '*.so' -o -iname '*.bak' \) -printf '%p\n'); do
    tstbin=$(readelf -l "$value" 2>/dev/null | grep -Pio 'executable|shared')
    if [ -z "$tstbin" ]; then
      tstbat=$(cat "$value" | head -c2 | grep -io '#!')
      if [ -n "$tstbat" ]; then
        perm=$(stat -c '%a' "$value")
        if [ "$perm" != "755" ]; then
          chmod 755 $value
          echo "Set script  755 $value"
          # set batch to 755
        fi
      else
        perm=$(stat -c '%a' "$value")
        if [ "$perm" != "644" ]; then
          chmod 644 $value
          echo "Set regular 644 $value"
          # set regular files to 644
        fi
      fi
      # above aren't elf binary
    else
      perm=$(stat -c '%a' "$value")
      if [ "$perm" != "755" ]; then
        chmod 755 $value
        echo "Set binary  755 $value"
        # set elf binaries to 755
      fi
    fi
  done
  unset IFS
  # process linux permissions for files and folders
else
  echo "Aborted."
fi
