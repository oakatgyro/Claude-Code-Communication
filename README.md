# 🤖 `Zellij` Multi-Agent Communication Demo

A demo system for agent-to-agent communication in a `zellij` environment.

## 🎯 Demo Overview

Experience a hierarchical command system: PRESIDENT → BOSS → Workers

### 👥 Agent Configuration

```
📊 PRESIDENT Tab (1 pane)
└── PRESIDENT: Project Manager

📊 boss Tab (1 panes)  
├── boss: Team Leader

📊 workers Tab (3 panes)  
├── worker1: Worker A
├── worker2: Worker B
└── worker3: Worker C
```

## 🚀 Quick Start

### 0. Clone Repository

```bash
git clone https://github.com/nishimoto265/Claude-Code-Communication.git
cd Claude-Code-Communication
```

### 1. Setup zellij Environment

⚠️ **Warning**: Existing sessions will be automatically removed.

```bash
./setup.sh
```

### 2. Run Demo

Type directly in PRESIDENT session:
```
You are the president. Follow the instructions.
```

## 📜 About Instructions

Role-specific instruction files for each agent:
- **PRESIDENT**: `instructions/president.md`
- **boss1**: `instructions/boss.md` 
- **worker1,2,3**: `instructions/worker.md`

**Claude Code Reference**: Check system structure in `CLAUDE.md`

**Key Points:**
- **PRESIDENT**: "You are the president. Follow the instructions." → Send command to boss
- **boss**: Receive PRESIDENT command → Send instructions to all workers → Report completion
- **workers**: Execute Hello World → Create completion files → Last worker reports

## 🎬 Expected Operation Flow

```
1. PRESIDENT → boss: "You are boss. Start Hello World project"
2. boss → workers: "You are worker[1-3]. Start Hello World task"  
3. workers → Create ./tmp/ files → Last worker → boss: "All tasks completed"
4. boss → PRESIDENT: "All completed"
```

## 🔧 Manual Operations

### Log Checking

```bash
# Check send logs
cat logs/send_log.txt

# Check specific agent logs
grep "boss" logs/send_log.txt

# Check completion files
ls -la ./tmp/worker*_done.txt
```


## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions via pull requests and issues are welcome!

---

🚀 **Experience Agent Communication!** 🤖✨ 