#!/bin/bash

set -e

echo "Installing Ralph Plan System..."

# Check for jq requirement
if ! command -v jq &> /dev/null; then
  echo ""
  echo "❌ Error: 'jq' is required but not installed."
  echo ""
  echo "Please install jq using one of the following commands:"
  echo ""
  echo "Ubuntu/Debian:"
  echo "  sudo apt-get update && sudo apt-get install -y jq"
  echo ""
  echo "Fedora/CentOS/RHEL:"
  echo "  sudo dnf install jq"
  echo ""
  echo "Arch Linux:"
  echo "  sudo pacman -S jq"
  echo ""
  echo "Alpine Linux:"
  echo "  apk add jq"
  echo ""
  echo "macOS (Homebrew):"
  echo "  brew install jq"
  echo ""
  exit 1
fi

# Create directory structure
mkdir -p plan/script
mkdir -p plan/templates
mkdir -p plan/archived

# Create script/ralph-once.sh
cat > plan/script/ralph-once.sh << 'EOF'
#!/bin/bash

set -e

opencode --prompt "You are a disciplined Software Engineer focused on execution within a strictly defined scope. \
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
Do not terminate processes you did not create." --model zai-coding-plan/glm-4.7
EOF

# Create script/ralph-yolo.sh
cat > plan/script/ralph-yolo.sh << 'EOF'
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
EOF

# Create script/archive.sh
cat > plan/script/archive.sh << 'EOF'
#!/bin/bash

# Get optional custom name argument
CUSTOM_NAME="$1"
# Generate date with C locale to ensure YYYY-MM-DD format
DATE=$(LC_TIME=C date +%Y%m%d%H%M)
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
EOF

# Create templates/prd.template.json
cat > plan/templates/prd.template.json << 'EOF'
[
  {
    "id": 1,
    "category": "setup",
    "description": "Project initialization",
    "steps": [
      "Initialize project structure",
      "Set up configuration files",
      "Install dependencies"
    ],
    "passes": false
  },
  {
    "id": 2,
    "category": "functional",
    "description": "Core feature implementation",
    "steps": [
      "Implement the main functionality",
      "Add error handling",
      "Write tests"
    ],
    "passes": false
  },
  {
    "id": 3,
    "category": "functional",
    "description": "Additional feature",
    "steps": [
      "Step 1: Do something",
      "Step 2: Do something else",
      "Step 3: Verify the implementation"
    ],
    "passes": false
  },
  {
    "id": 4,
    "category": "testing",
    "description": "Test coverage",
    "steps": [
      "Write unit tests",
      "Write integration tests",
      "Ensure all tests pass"
    ],
    "passes": false
  }
]
EOF

# Create templates/progress.template.txt
cat > plan/templates/progress.template.txt << 'EOF'
Write your progress here so others can continue your work

---

EOF

# Create templates/spec.template.md
cat > plan/templates/spec.template.md << 'EOF'
# Project Title - Specification

## Overview

Brief description of what this project aims to accomplish.

## Requirements

List the main requirements and features to be implemented.

## API Endpoints / Components

### Endpoint/Component 1

Description of the endpoint or component.

**Type:** GET/POST/PUT/DELETE

**Path:** `/path/to/endpoint`

**Request/Implementation:**
```typescript
// Example type definitions or interfaces
export type ExampleType = {
  field1: string;
  field2: number;
};
```

**Response/Expected Output:**
```json
{
  "field1": "value",
  "field2": 123
}
```

### Endpoint/Component 2

Description of another endpoint or component.

**Type:** GET/POST/PUT/DELETE

**Path:** `/path/to/endpoint`

**Request/Implementation:**
```typescript
// Example type definitions or interfaces
export interface ExampleInterface {
  id: string;
  data: any;
}
```

**Response/Expected Output:**
```json
{
  "id": "unique-id",
  "data": {}
}
```

## Technical Details

### Technology Stack

- Runtime: e.g., Bun, Node.js
- Language: TypeScript, JavaScript
- Framework: e.g., Express, Fastify, or Bun's native HTTP

### Key Libraries

List any important libraries or dependencies needed.

## Implementation Notes

Additional context, constraints, or special considerations for implementation.

## References

Links to documentation or external resources.
EOF

# Create default working files from templates
cp plan/templates/prd.template.json plan/prd.json
cp plan/templates/progress.template.txt plan/progress.txt
cp plan/templates/spec.template.md plan/spec.md

# Make scripts executable
chmod +x plan/script/*.sh

# Add scripts to package.json
if [ -f "package.json" ]; then
  jq '.scripts["ralph:once"] = ". plan/script/ralph-once.sh" |
      .scripts["ralph:yolo"] = ". plan/script/ralph-yolo.sh 10" |
      .scripts["ralph:archive"] = ". plan/script/archive.sh"' \
      package.json > package.json.tmp && mv package.json.tmp package.json
  echo "✓ Added npm scripts to package.json"
else
  echo "Warning: package.json not found in current directory"
fi

echo "✅ Ralph Wiggum loop installed successfully!"
echo "📝 Edit plan/spec.md, plan/prd.json, and plan/progress.txt to define your project"
echo "🚀 Run 'bun run ralph:once' to execute one task, or 'bun run ralph:yolo' for multiple iterations"
