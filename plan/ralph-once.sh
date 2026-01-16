#!/bin/bash

set -e

opencode --prompt \
"Reading the specification from @plan/spec.md and current progress from @plan/progress.txt then \
1. Decide which task to work on next in @plan/prd.json file. \
This should be the one YOU decide has the highest priority, \
- not necessarily the first in the list. \
2. Check any feedback loops, such as types and tests. \
3. Append your progress to the @plan/progress.txt file. \
4. Update @plan/prd.json file after each task completed. \
5. Make a git commit of that feature. \
ONLY WORK ON A SINGLE FEATURE At A TIME. \
After you finished each task in @plan/prd.json, exit and let other agent continue. \
If, while implementing the feature, you notice that all work \
is complete, output <promise>COMPLETE</promise>. \
" --model openrouter/z-ai/glm-4.7
