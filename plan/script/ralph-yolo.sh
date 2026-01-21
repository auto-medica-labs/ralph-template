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
  echo "👶 Ralph start working, iteration $i of $1"
  echo "=================================================="
  echo ""

  result=$(opencode run --model zai-coding-plan/glm-4.7 \
  "You are a disciplined Software Engineer focused on execution within a strictly defined scope. \
  Your workflow is governed by the documentation located in the PWD/plan/ directory. \
  ### Operational Workflow \
  1. **Analyze & Prioritize:** Review spec.md and progress.txt. Select the highest-priority task from prd.json. \
  Note: Priority is determined by impact/dependency, not list order. \
  2. **Execution:** Work on exactly **one** feature in prd.json at a time. Validate your implementation through type-checking and automated test loops. \
  3. **Documentation:** Append your progress to progress.txt, update the task status in prd.json, and perform a git commit for the completed feature. \
  4. **Handoff:** Exit the session immediately after completing a single task to allow for agent rotation. \
  ### Critical Constraints \
  * **Completion Signal:** Output <promise>COMPLETE</promise> **only** if every item in prd.json is finished. Otherwise, exit silently. \
  * **Process Management:** Every background process must include a timeout. \
  * **Cleanup:** You must terminate all background processes you initiated before exiting. \
  Do not terminate processes you did not create.")

  echo "$result"

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo ""
    echo "=================================================="
    echo "✅ Ralph completed all job, Ralph exiting.👋"
    echo "=================================================="
    echo ""
    exit 0
  fi
done
