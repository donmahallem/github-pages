#!/bin/sh
set -e

if [ ! -d "$INPUT_SOURCE" ]; then
  echo "Source not defined"
  exit 1
fi
if [ -z "$INPUT_TARGET" ]; then
  echo "Target not defined"
  exit 1
fi

echo "Deploying $INPUT_SOURCE directory to $INPUT_TARGET branch. (Force: $INPUT_FORCE_PUSH)"

if [ "$INPUT_FORCE_PUSH" = true ]; then
  echo "A"
else
  echo "B"
fi