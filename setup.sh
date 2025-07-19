#!/bin/bash

# 🚀 Multi-Agent Communication Demo Environment Setup
# Reference: setup_full_environment.sh

set -e  # Stop on error

# Colored log functions
log_info() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;34m[SUCCESS]\033[0m $1"
}

echo "🤖 Multi-Agent Communication Demo Environment Setup"
echo "==========================================="
echo ""

# STEP 1: Clean up existing sessions
log_info "🧹 Starting cleanup of existing sessions..."

tmux kill-session -t multiagent 2>/dev/null && log_info "multiagent session deleted" || log_info "multiagent session did not exist"
tmux kill-session -t president 2>/dev/null && log_info "president session deleted" || log_info "president session did not exist"

# Clear completion files
mkdir -p ./tmp
rm -f ./tmp/worker*_done.txt 2>/dev/null && log_info "Cleared existing completion files" || log_info "Completion files did not exist"

log_success "✅ Cleanup completed"
echo ""

# STEP 2: Create multiagent session (4 panes: boss1 + worker1,2,3)
log_info "📺 Starting multiagent session creation (4 panes)..."

# Create session
log_info "Creating session..."
tmux new-session -d -s multiagent -n "agents"

# Verify session creation
if ! tmux has-session -t multiagent 2>/dev/null; then
    echo "❌ Error: Failed to create multiagent session"
    exit 1
fi

log_info "Session created successfully"

# Create 2x2 grid (using window names, independent of base-index)
log_info "Creating grid..."

# Horizontal split (specified by window name)
log_info "Executing horizontal split..."
tmux split-window -h -t "multiagent:agents"

# Select top-left pane and split vertically
log_info "Executing left vertical split..."
tmux select-pane -t "multiagent:agents" -L  # Select left pane
tmux split-window -v

# Select top-right pane and split vertically
log_info "Executing right vertical split..."
tmux select-pane -t "multiagent:agents" -R  # Select right pane
tmux split-window -v

# Verify pane layout
log_info "Verifying pane layout..."
PANE_COUNT=$(tmux list-panes -t "multiagent:agents" | wc -l)
log_info "Number of panes created: $PANE_COUNT"

if [ "$PANE_COUNT" -ne 4 ]; then
    echo "❌ Error: Expected 4 panes but got: $PANE_COUNT"
    exit 1
fi

# Get physical pane layout (starting from top-left)
log_info "Getting pane numbers..."
# Get tmux pane numbers based on position
PANE_IDS=($(tmux list-panes -t "multiagent:agents" -F "#{pane_id}" | sort))

log_info "Detected panes: ${PANE_IDS[*]}"

# Set pane titles and setup
log_info "Setting pane titles..."
PANE_TITLES=("boss1" "worker1" "worker2" "worker3")

for i in {0..3}; do
    PANE_ID="${PANE_IDS[$i]}"
    TITLE="${PANE_TITLES[$i]}"
    
    log_info "Configuring: ${TITLE} (${PANE_ID})"
    
    # Set pane title
    tmux select-pane -t "$PANE_ID" -T "$TITLE"
    
    # Set working directory
    tmux send-keys -t "$PANE_ID" "cd $(pwd)" C-m
    
    # Set colored prompt
    if [ $i -eq 0 ]; then
        # boss1: red
        tmux send-keys -t "$PANE_ID" "export PS1='(\[\033[1;31m\]${TITLE}\[\033[0m\]) \[\033[1;32m\]\w\[\033[0m\]\$ '" C-m
    else
        # workers: blue
        tmux send-keys -t "$PANE_ID" "export PS1='(\[\033[1;34m\]${TITLE}\[\033[0m\]) \[\033[1;32m\]\w\[\033[0m\]\$ '" C-m
    fi
    
    # Welcome message
    tmux send-keys -t "$PANE_ID" "echo '=== ${TITLE} Agent ==='" C-m
done

log_success "✅ multiagent session created successfully"
echo ""

# STEP 3: Create president session (1 pane)
log_info "👑 Starting president session creation..."

tmux new-session -d -s president
tmux send-keys -t president "cd $(pwd)" C-m
tmux send-keys -t president "export PS1='(\[\033[1;35m\]PRESIDENT\[\033[0m\]) \[\033[1;32m\]\w\[\033[0m\]\$ '" C-m
tmux send-keys -t president "echo '=== PRESIDENT Session ==='" C-m
tmux send-keys -t president "echo 'Project Overall Manager'" C-m
tmux send-keys -t president "echo '========================'" C-m

log_success "✅ president session created successfully"
echo ""

# STEP 4: Environment verification and display
log_info "🔍 Verifying environment..."

echo ""
echo "📊 Setup Results:"
echo "==================="

# Verify tmux sessions
echo "📺 Tmux Sessions:"
tmux list-sessions
echo ""

# Display pane configuration
echo "📋 Pane Configuration:"
echo "  multiagent session (4 panes):"
tmux list-panes -t "multiagent:agents" -F "    Pane #{pane_id}: #{pane_title}"
echo ""
echo "  president session (1 pane):"
echo "    Pane: PRESIDENT (Project Overall Manager)"

echo ""
log_success "🎉 Demo environment setup completed!"
echo ""
echo "📋 Next Steps:"
echo "  1. 🔗 Attach Sessions:"
echo "     tmux attach-session -t multiagent   # Check multi-agent"
echo "     tmux attach-session -t president    # Check president"
echo ""
echo "  2. 🤖 Start Claude Code:"
echo "     # Step 1: President authentication"
echo "     tmux send-keys -t president 'claude' C-m"
echo "     # Step 2: After authentication, start multiagent all at once"
echo "     # Start claude using each pane's ID"
echo "     tmux list-panes -t multiagent:agents -F '#{pane_id}' | while read pane; do"
echo "         tmux send-keys -t \"\$pane\" 'claude' C-m"
echo "     done"
echo ""
echo "  3. 📜 Check Instructions:"
echo "     PRESIDENT: instructions/president.md"
echo "     boss1: instructions/boss.md"
echo "     worker1,2,3: instructions/worker.md"
echo "     System Structure: CLAUDE.md"
echo ""
echo "  4. 🎯 Run Demo: Type 'You are president. Follow the instructions' to PRESIDENT"

