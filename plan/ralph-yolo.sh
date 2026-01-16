#!/bin/bash

# ralph-yolo.sh
# Usage: ./ralph-yolo.sh <iterations>

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <iterations>"
  exit 1
fi

git clean -fd
git restore .

for ((i=1; i<=$1; i++)); do
  echo ""
  echo "=================================================="
  echo "🚀 Starting Iteration $i of $1"
  echo "=================================================="
  echo ""

  result=$(opencode run --model nvidia/qwen/qwen3-coder-480b-a35b-instruct \
  "You are typical software engineer, you only work for a narrow scoped that you been told to do, nothing more, nothing less. \
  Reading the specification from @plan/spec.md and current progress from @plan/progress.txt then \
  1. Decide which task to work on next in @plan/prd.json file. \
  This should be the one YOU decide has the highest priority \
  - not necessarily the first in the list. \
  2. Check any feedback loops, such as types and tests. \
  3. Append your progress to the @plan/progress.txt file. \
  4. Update @plan/prd.json file after each task completed. \
  5. Make a git commit of that feature. \
  ONLY WORK ON A SINGLE FEATURE At A TIME. \
  After you finished each task in @plan/prd.json, exit and let other agent continue. \
  If, while implementing the feature, you notice that **ALL** work items \
  is complete, output <promise>COMPLETE</promise>. \
  Let me repeat that again: only output <promise>COMPLETE</promise> when **ALL** work items \
  in @plan/prd.json are completed; otherwise, just exit without outputting anything. \
  Always kill all background processes that you start before exiting the session.")

  echo "$result"

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo "PRD complete, exiting."
    exit 0
  fi
done
