#!/bin/bash

# Get optional custom name argument
CUSTOM_NAME="$1"
# Generate date with C locale to ensure YYYY-MM-DD format
DATE=$(LC_TIME=C date +%Y-%m-%d)
# Create folder name with optional custom name suffix
if [ -n "$CUSTOM_NAME" ]; then
  FOLDER_NAME="${DATE}-${CUSTOM_NAME}"
else
  FOLDER_NAME="${DATE}"
fi
# Check if all 3 files exist
if [ ! -f "plan/spec.md" ] || [ ! -f "plan/prd.json" ] || [ ! -f "plan/progress.txt" ]; then
  echo "Error: Not all files found. All 3 files (spec.md, prd.json, progress.txt) must exist to archive."
  exit 1
fi

# Create target directory
TARGET_DIR="plan/archived/${FOLDER_NAME}"
mkdir -p "$TARGET_DIR"
# Move files
mv plan/spec.md plan/prd.json plan/progress.txt "$TARGET_DIR/"
echo "Archived files to: $TARGET_DIR"
