#!/bin/bash

CFG+=(cortexM0l cortexM0b cortexM3l cortexM3b cortexM4l cortexM4b cortexM4lf cortexM4bf cortexM7l cortexM7b cortexM7ls cortexM7bs cortexM7lf cortexM7bf ARMv8MBLl)

for a in ${CFG[@]}; do
  ctest --test-dir build --build-config $a $1
done

