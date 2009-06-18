#!/bin/bash

# attempt to apply all the patches located in tools/patches/
for i in tools/patches/*.patch
do
  # first, check if this patch applies
  patch --dry-run -N -p1 -d mozilla/ <$i >/dev/null 2>/dev/null
  if [ $? = 0 ]; then
    # it works, just apply it
    patch -p1 -d mozilla/ <$i
  else
    # it doesn't apply, check if it is already applied
    patch --dry-run -R -N -p1 -d mozilla/ <$i >/dev/null 2>/dev/null
    if [ $? = 0 ]; then
      echo $i already applied
    else
      # either way, it doesn't apply. Display a warning showing the problem
      echo warning: $i failed to apply
      echo --------
      patch --dry-run -N -p1 -d mozilla/ <$i
      echo --------
    fi
  fi
done
