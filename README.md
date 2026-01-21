# Ralph Wiggum Agentic Workflow Demo

This repository demonstrates an automatic Ralph workflow for autonomous software development tasks using the `opencode` CLI tool.

## Quick Setup in Your Project

To add the Ralph to any project:

```bash
curl -sSL https://raw.githubusercontent.com/dheerapat/ralph-erp-demo/refs/heads/main/install-ralph.sh | bash
```

This will:
- Create the `/plan/` directory structure with all necessary files
- Add npm scripts (`ralph:once`, `ralph:yolo`, `ralph:archive`) to your `package.json`
- Set up template files for specifications, PRD, and progress tracking

**Requirements:**
- `jq` must be installed (the install script will check and provide installation instructions if missing)

## How to Use This Workflow

### Step 1: Prepare Your Task Definition

Copy the templates and edit them:

```bash
cp plan/templates/spec.template.md plan/spec.md
cp plan/templates/prd.template.json plan/prd.json
cp plan/templates/progress.template.txt plan/progress.txt
```

Edit the following files in the `plan/` directory:

- **`plan/spec.md`** - Write detailed specifications for what you want to build
- **`plan/prd.json`** - Define your tasks as a JSON array with:
  - `id`: Unique identifier
  - `category`: Task category (e.g., "functional", "testing")
  - `description`: Brief description of the task
  - `steps`: Array of specific steps to complete
  - `passes`: Boolean (start with `false`, agent will update to `true` when done)
- **`plan/progress.txt`** - Keep initial state (the agent will update this as it works)

### Step 2: Run the Ralph Agent

Choose one of the following modes:

**Single Task Execution:**
```bash
bun run ralph:once
```

**Fully Autonomous Mode** (executes multiple iterations until all tasks complete):
```bash
bun run ralph:yolo <iterations>
```
Replace `<iterations>` with the maximum number of iterations (e.g., `bun run ralph:yolo 10`)

Ralph will:
1. Analyze `spec.md` and `progress.txt`
2. Select the highest-priority task from `prd.json`
3. Implement one feature at a time
4. Validate through type-checking and automated tests
5. Update `progress.txt` and mark tasks complete in `prd.json`
6. Commit each completed feature to git
7. Exit after each task to allow for agent rotation

### Step 3: Archive When Complete

After all items in `prd.json` are marked complete:

```bash
bun run ralph:archive <optional-name>
```

This will:
- Create a timestamped folder in `plan/archived/`
- Move `spec.md`, `prd.json`, and `progress.txt` to the archive
- Allow you to start fresh with a new task

## Example: Mock ERP Server

The current `plan/` files contain an example task to build a mock ERP HTTP server for inventory management with:
- Base endpoint `/`
- GET `/inventory` endpoint
- POST `/reserve` endpoint
- POST `/release` endpoint

**Templates Available:**
- `plan/templates/spec.template.md` - Template for writing specifications
- `plan/templates/prd.template.json` - Template for defining tasks
- `plan/templates/progress.template.txt` - Template for tracking progress

## Requirements

- Bun runtime
- `opencode` CLI tool with access to the `zai-coding-plan/glm-4.7` model

## Install Dependencies

```bash
bun install
```
