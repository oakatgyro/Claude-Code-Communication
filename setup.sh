#!/bin/bash

# 🚀 Multi-Agent Communication Demo Environment Setup (Zellij Version)
# Reference: setup_full_environment.sh

set -e  # Stop on error

# Colored log functions
log_info() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;34m[SUCCESS]\033[0m $1"
}

echo "🤖 Multi-Agent Communication Demo Environment Setup (Zellij Version)"
echo "==========================================="
echo ""

# STEP 1: Clean up existing sessions
log_info "🧹 Starting cleanup of existing sessions..."

zellij delete-session president --force 2>/dev/null && log_info "president session deleted" || log_info "president session did not exist"
zellij delete-session boss --force 2>/dev/null && log_info "boss session deleted" || log_info "boss session did not exist"
zellij delete-session workers --force 2>/dev/null && log_info "workers session deleted" || log_info "workers session did not exist"

# Clear completion files
mkdir -p ./tmp
rm -f ./tmp/worker*_done.txt 2>/dev/null && log_info "Cleared existing completion files" || log_info "Completion files did not exist"

log_success "✅ Cleanup completed"
echo ""

# STEP 2: Create president session (1 pane)
log_info "👑 Starting president session creation..."

# Create president session in background
zellij --new-session-with-layout ./zellij/president.kdl attach president --create-background
if ! zellij list-sessions | grep -q president; then
    log_info "president session did not exist"
    exit 1
else
    log_info "president session created successfully"
fi
log_success "✅ president session created successfully"
echo ""

# STEP 3: Create boss session (1 pane)
log_info "🔧 Starting boss session creation..."

# Create boss session in background
zellij --new-session-with-layout ./zellij/boss.kdl attach boss --create-background

log_success "✅ boss session created successfully"
echo ""

# STEP 4: Create workers session with 3 tabs (worker1, worker2, worker3)
log_info "👷 Starting workers session creation..."

# Create workers session with the layout
zellij --new-session-with-layout ./zellij/workers.kdl attach workers --create-background

log_success "✅ workers session created successfully with 3 tabs"
echo ""

# STEP 5: Environment verification and display
echo ""
log_success "🎉 Demo environment setup completed!"
echo ""
echo "📋 Next Steps:"
echo "  1. 🔗 Attach Sessions In New Tabs:"
echo "     zellij attach president     # Check president"
echo "     zellij attach boss         # Check boss"
echo "     zellij attach workers      # Check workers"
echo ""
echo "  2. 🎯 Run Demo: Type 'You are president. Follow the instructions' to PRESIDENT"