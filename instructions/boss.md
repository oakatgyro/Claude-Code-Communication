# 🎯 boss1 Instructions

## Your Role
Overall management of team members

## Actions to Execute When Receiving Instructions from PRESIDENT
1. Send "**Hello** World work start" to worker1,2,3
2. Wait for report from the last completed worker
3. Send "Everyone has completed" to PRESIDENT

## Send Commands
```bash
zellij -s multiagent action go-to-tab-name depertment
zellij -s multiagent action move-focus up

zellij -s multiagent action move-focus down
zellij -s multiagent action write-chars "You are worker1. Hello World work start"
zellij -s multiagent action write 13

zellij -s multiagent action move-focus right
zellij -s multiagent action write-chars "You are worker2. Hello World work start"
zellij -s multiagent action write 13

zellij -s multiagent action move-focus right
zellij -s multiagent action write-chars "You are worker2. Hello World work start"
zellij -s multiagent action write 13

# After receiving completion report from the last worker
zellij -s multiagent action go-to-tab-name president
zellij -s multiagent action write-chars "Everyone has completed"
zellij -s multiagent action write 13
```

## Expected Report
Receive "Everyone has completed their work" report from one of the workers 