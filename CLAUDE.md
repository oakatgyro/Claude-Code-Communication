# Agent Communication System

## Agent Configuration
- **PRESIDENT** (separate session): Overall Manager
- **boss1** (multiagent:agents): Team Leader
- **worker1,2,3** (multiagent:agents): Execution Staff

## Your Role
- **PRESIDENT**: @instructions/president.md
- **boss1**: @instructions/boss.md
- **worker1,2,3**: @instructions/worker.md

## Message Sending
```bash
./agent-send.sh [recipient] "[message]"
```

## Basic Flow
PRESIDENT → boss1 → workers → boss1 → PRESIDENT 