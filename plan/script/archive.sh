#!/bin/bash

KEEP_SPEC=false
CUSTOM_NAME=""

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --keep-spec)
      KEEP_SPEC=true
      shift
      ;;
    -n|--name)
      CUSTOM_NAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--keep-spec] [-n|--name <name>]"
      exit 1
      ;;
  esac
done

# Generate date with C locale to ensure YYYY-MM-DD format
DATE=$(LC_TIME=C date +%Y%m%d%H%M)
# Create folder name with optional custom name suffix
if [ -n "$CUSTOM_NAME" ]; then
  FOLDER_NAME="${DATE}-${CUSTOM_NAME}"
else
  FOLDER_NAME="${DATE}"
fi

# Determine which files to archive
if [ "$KEEP_SPEC" = true ]; then
  # Check if prd.json and progress.txt exist
  if [ ! -f "plan/prd.json" ] || [ ! -f "plan/progress.txt" ]; then
    echo "Error: prd.json and progress.txt must exist to archive with --keep-spec."
    exit 1
  fi
  FILES_TO_ARCHIVE="plan/prd.json plan/progress.txt"
else
  # Check if all 3 files exist
  if [ ! -f "plan/spec.md" ] || [ ! -f "plan/prd.json" ] || [ ! -f "plan/progress.txt" ]; then
    echo "Error: Not all files found. All 3 files (spec.md, prd.json, progress.txt) must exist to archive."
    exit 1
  fi
  FILES_TO_ARCHIVE="plan/spec.md plan/prd.json plan/progress.txt"
fi

# Create target directory
TARGET_DIR="plan/archived/${FOLDER_NAME}"
mkdir -p "$TARGET_DIR"
# Move files
mv $FILES_TO_ARCHIVE "$TARGET_DIR/"

# Populate new files from templates
if [ "$KEEP_SPEC" = false ]; then
  cp plan/templates/spec.template.md plan/spec.md
fi

cp plan/templates/prd.template.json plan/prd.json
cp plan/templates/progress.template.txt plan/progress.txt

echo "Archived files to: $TARGET_DIR"
