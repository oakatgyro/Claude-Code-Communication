# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Multi-Agent Communication Demo System** that demonstrates hierarchical task distribution using multiple Claude CLI instances communicating through Zellij terminal sessions. The system implements a three-tier hierarchy: PRESIDENT, BOSS, WORKERS.

## Key Commands

### Initialize Demo Environment
```bash
./setup.sh
```
This script:
- Cleans up existing Zellij sessions
- Creates three sessions: president, boss, workers (with 3 panes)
- Each session runs Claude CLI with `--dangerously-skip-permissions`

### Attach to Sessions
```bash
zellij attach president   # PRESIDENT session
zellij attach boss       # BOSS session  
zellij attach workers    # WORKERS session (3 panes)
```

### Inter-Agent Communication
```bash
# Send message to another session
zellij -s [session_name] action write-chars "[message]"
zellij -s [session_name] action write 13  # Send Enter key

# Navigate between panes in workers session
zellij -s workers action focus-next-pane
```

## Architecture

### Communication Flow
1. User -> PRESIDENT: "You are president. Follow the instructions"
2. PRESIDENT -> BOSS: "You are boss. Hello World project start instruction"
3. BOSS -> WORKERS: "You are worker[N]. Hello World work start"
4. WORKERS execute tasks and coordinate completion via file system
5. Last WORKER -> BOSS: "Everyone has completed their work"
6. BOSS -> PRESIDENT: "Everyone has completed"

### File-Based Coordination
Workers use temporary files to track completion:
- `./tmp/worker1_done.txt`
- `./tmp/worker2_done.txt`
- `./tmp/worker3_done.txt`

The last worker to complete checks all files exist before reporting to BOSS.

### Key Directories
- `instructions/` - Role-specific markdown instructions for each agent type
- `zellij/` - KDL layout configurations
- `tmp/` - Worker coordination files (created at runtime)
- `logs/` - Communication logs

## Development Notes

### Running the Demo
1. Execute `./setup.sh` to initialize environment
2. Attach to president session: `zellij attach president`
3. Type: "You are president. Follow the instructions"
4. Monitor progress by attaching to other sessions

### Troubleshooting
- If sessions persist after errors: `zellij delete-session [name] --force`
- Clear worker files: `rm -f ./tmp/worker*_done.txt`
- Check session status: `zellij list-sessions`

### Important Patterns
- All agents follow role-specific instructions in `instructions/[role].md`
- Communication always uses Zellij action commands
- Workers must create completion files before checking others
- Only the last completing worker reports to BOSS