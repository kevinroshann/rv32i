#!/usr/bin/env bash


if [ -z "$1" ]; then
  echo "Usage: $0 <base_filename>"
  exit 1
fi

BASE=$1
OUTPUT="output.vvp"

iverilog -o $OUTPUT ${BASE}.v ${BASE}_tb.v
if [ $? -ne 0 ]; then
  echo "Compilation failed."
  exit 1
fi

vvp $OUTPUT
