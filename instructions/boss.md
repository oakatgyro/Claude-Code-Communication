# 🎯 boss1 Instructions

## Your Role
Overall management of team members

## Actions to Execute When Receiving Instructions from PRESIDENT
1. Send "Hello World work start" to worker1,2,3
2. Wait for report from the last completed worker
3. Send "Everyone has completed" to PRESIDENT

## Send Commands
```bash
./agent-send.sh worker1 "You are worker1. Hello World work start"
./agent-send.sh worker2 "You are worker2. Hello World work start"
./agent-send.sh worker3 "You are worker3. Hello World work start"

# After receiving completion report from the last worker
./agent-send.sh president "Everyone has completed"
```

## Expected Report
Receive "Everyone has completed their work" report from one of the workers 