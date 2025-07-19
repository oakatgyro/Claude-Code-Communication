#!/bin/bash

# 🚀 Inter-Agent Message Sending Script

# Dynamically get tmux base-index and pane-base-index
get_tmux_indices() {
    local session="$1"
    local window_index=$(tmux show-options -t "$session" -g base-index 2>/dev/null | awk '{print $2}')
    local pane_index=$(tmux show-options -t "$session" -g pane-base-index 2>/dev/null | awk '{print $2}')

    # Default values
    window_index=${window_index:-0}
    pane_index=${pane_index:-0}

    echo "$window_index $pane_index"
}

# Agent to tmux target mapping
get_agent_target() {
    case "$1" in
        "president") echo "president" ;;
        "boss1"|"worker1"|"worker2"|"worker3")
            # Dynamically get multiagent session index
            if tmux has-session -t multiagent 2>/dev/null; then
                local indices=($(get_tmux_indices multiagent))
                local window_index=${indices[0]}
                local pane_index=${indices[1]}

                # Get by window name (independent of base-index)
                local window_name="agents"

                # Calculate pane number
                case "$1" in
                    "boss1") echo "multiagent:$window_name.$((pane_index))" ;;
                    "worker1") echo "multiagent:$window_name.$((pane_index + 1))" ;;
                    "worker2") echo "multiagent:$window_name.$((pane_index + 2))" ;;
                    "worker3") echo "multiagent:$window_name.$((pane_index + 3))" ;;
                esac
            else
                echo ""
            fi
            ;;
        *) echo "" ;;
    esac
}

show_usage() {
    cat << EOF
🤖 Inter-Agent Message Sending

Usage:
  $0 [agent_name] [message]
  $0 --list

Available agents:
  president - Project Overall Manager
  boss1     - Team Leader  
  worker1   - Execution Staff A
  worker2   - Execution Staff B
  worker3   - Execution Staff C

Examples:
  $0 president "Follow the instructions"
  $0 boss1 "Hello World project start instruction"
  $0 worker1 "Work completed"
EOF
}

# Display agent list
show_agents() {
    echo "📋 Available agents:"
    echo "=========================="

    # Check president session
    if tmux has-session -t president 2>/dev/null; then
        echo "  president → president       (Project Overall Manager)"
    else
        echo "  president → [not started]   (Project Overall Manager)"
    fi

    # Check multiagent session
    if tmux has-session -t multiagent 2>/dev/null; then
        local boss1_target=$(get_agent_target "boss1")
        local worker1_target=$(get_agent_target "worker1")
        local worker2_target=$(get_agent_target "worker2")
        local worker3_target=$(get_agent_target "worker3")

        echo "  boss1     → ${boss1_target:-[error]}     (Team Leader)"
        echo "  worker1   → ${worker1_target:-[error]}   (Execution Staff A)"
        echo "  worker2   → ${worker2_target:-[error]}   (Execution Staff B)"
        echo "  worker3   → ${worker3_target:-[error]}   (Execution Staff C)"
    else
        echo "  boss1     → [not started]   (Team Leader)"
        echo "  worker1   → [not started]   (Execution Staff A)"
        echo "  worker2   → [not started]   (Execution Staff B)"
        echo "  worker3   → [not started]   (Execution Staff C)"
    fi
}

# Log recording
log_send() {
    local agent="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    mkdir -p logs
    echo "[$timestamp] $agent: SENT - \"$message\"" >> logs/send_log.txt
}

# Send message
send_message() {
    local target="$1"
    local message="$2"
    
    echo "📤 Sending: $target ← '$message'"
    
    # Clear Claude Code prompt once
    tmux send-keys -t "$target" C-c
    sleep 0.3
    
    # Send message
    tmux send-keys -t "$target" "$message"
    sleep 0.1
    
    # Press enter
    tmux send-keys -t "$target" C-m
    sleep 0.5
}

# Check target existence
check_target() {
    local target="$1"
    local session_name="${target%%:*}"
    
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        echo "❌ Session '$session_name' not found"
        return 1
    fi
    
    return 0
}

# Main process
main() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi
    
    # --list option
    if [[ "$1" == "--list" ]]; then
        show_agents
        exit 0
    fi
    
    if [[ $# -lt 2 ]]; then
        show_usage
        exit 1
    fi
    
    local agent_name="$1"
    local message="$2"
    
    # Get agent target
    local target
    target=$(get_agent_target "$agent_name")
    
    if [[ -z "$target" ]]; then
        echo "❌ Error: Unknown agent '$agent_name'"
        echo "Available agents: $0 --list"
        exit 1
    fi
    
    # Check target
    if ! check_target "$target"; then
        exit 1
    fi
    
    # Send message
    send_message "$target" "$message"
    
    # Log recording
    log_send "$agent_name" "$message"
    
    echo "✅ Send completed: '$message' to $agent_name"
    
    return 0
}

main "$@" 