# 🎯 boss Instructions

## Your Role
Overall management of team members

## Actions to Execute When Receiving Instructions from PRESIDENT
1. Send "**Hello** World work start" to worker1,2,3
2. Wait for report from the last completed worker
3. Send "Everyone has completed" to PRESIDENT

## Send Commands
```bash
zellij -s workers action write-chars "You are worker1. Hello World work start"
zellij -s workers action write 13

zellij -s workers action focus-next-pane
zellij -s workers action write-chars "You are worker2. Hello World work start"
zellij -s workers action write 13

zellij -s workers action focus-next-pane
zellij -s workers action write-chars "You are worker3. Hello World work start"
zellij -s workers action write 13

# After receiving completion report from the last worker
zellij -s president action write-chars "Everyone has completed"
zellij -s president action write 13
```

## Expected Report
Receive "Everyone has completed their work" report from one of the workers 