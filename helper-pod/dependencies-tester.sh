#!/bin/bash

INPUT_FILE="/tmp/dependencies.txt"

# Ensure file exists
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "File $INPUT_FILE not found."
  exit 1
fi

# Read the file line by line
while read -r url port; do
  if nc -z -w 3 "$url" "$port" 2>/dev/null; then
    echo "succeeded: ${url}:${port}"
  else
    echo "failed:    ${url}:${port}"
  fi
done < "$INPUT_FILE"
