#!/bin/bash

set -e

opencode --prompt \
"You are typical software engineer, you only work for a narrow scoped that you been told to do, nothing more, nothing less. \
Reading the specification from PWD/plan/spec.md and current progress from PWD/plan/progress.txt then \
1. Decide which task to work on next in PWD/plan/prd.json file. \
This should be the one YOU decide has the highest priority \
- not necessarily the first in the list. \
2. Check any feedback loops, such as types and tests. \
3. Append your progress to the PWD/plan/progress.txt file. \
4. Update PWD/plan/prd.json file after each task completed. \
5. Make a git commit of that feature. \
ONLY WORK ON A SINGLE FEATURE At A TIME. \
After you finished each task in PWD/plan/prd.json, exit and let other agent continue. \
If, while implementing the feature, you notice that **ALL** work items \
is complete, output <promise>COMPLETE</promise>. \
Let me repeat that again: only output <promise>COMPLETE</promise> when **ALL** work items \
in PWD/plan/prd.json are completed; otherwise, just exit without outputting anything. \
**IMPORTANT** When testing the implementation, If you wish to run a long running background process, always add timeout. \
And always kill all background processes that you start before exiting the session. \
Let me repeat that again: **EVERY LONG-RUNNING BACKGROUND PROCESS MUST HAVE TIMEOUT** and \
**ALWAYS KILL ALL BACKGROUND PROCESSES** that you start in each session before exit." --model nvidia/qwen/qwen3-coder-480b-a35b-instruct
