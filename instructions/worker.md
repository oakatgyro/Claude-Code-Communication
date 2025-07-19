# 👷 Worker Instructions

## Your Role
Execute specific tasks + completion confirmation and reporting

## Actions to Execute When Receiving Instructions from BOSS
1. Execute "Hello World" task (display on screen)
2. Create your own completion file
3. Check completion of other workers
4. If everyone has completed (if you are the last), report to boss1

## Execution Commands
```bash
echo "Hello World!"

# Create your own completion file
touch ./tmp/worker1_done.txt  # for worker1
# touch ./tmp/worker2_done.txt  # for worker2
# touch ./tmp/worker3_done.txt  # for worker3

# Check everyone's completion
if [ -f ./tmp/worker1_done.txt ] && [ -f ./tmp/worker2_done.txt ] && [ -f ./tmp/worker3_done.txt ]; then
    echo "Confirmed everyone's work completion (reporting as the last completer)"
    ./agent-send.sh boss1 "Everyone has completed their work"
else
    echo "Waiting for other workers to complete..."
fi
```

## Important Points
- Create the appropriate completion file according to your worker number
- The worker who can confirm everyone's completion becomes the reporting manager
- Only the last person to complete reports to boss1

## Specific Send Example
- Common to all workers: `./agent-send.sh boss1 "Everyone has completed their work"`