# fast-cli-skill

一个用于现代快速命令行工具的 OpenCode 技能，替代传统的 GNU/Unix 工具。

## 概述

本技能提供了一套现代、快速、用户友好的命令行工具指南，用于替代传统的 GNU/Unix 工具。这些工具通常用 Rust 编写，性能更好，输出更美观。

## 支持的工具

| 现代工具 | 替代传统工具 | 用途 |
|----------|--------------|------|
| `rg` (ripgrep) | `grep` | 快速递归搜索文件内容 |
| `fd` | `find` | 快速查找文件 |
| `bat` | `cat` | 语法高亮查看文件 |
| `eza` | `ls` | 现代目录列表 |
| `delta` | `diff` | 更好的差异查看器 |
| `sd` | `sed` | 快速文本替换 |
| `hyperfine` | `time` | 命令基准测试 |
| `dust` | `du` | 磁盘使用查看 |
| `duf` | `df` | 现代磁盘空间查看 |
| `procs` | `ps` | 现代进程查看器 |
| `btm` | `top` | 系统监控 |
| `choose` | `cut` | 列选择器 |
| `xsv` | `csvtool` | CSV 处理 |
| `jq` | - | JSON 处理 |
| `yq` | - | YAML/TOML 处理 |
| `broot` | `tree` | 树形导航 |

## 安装

### macOS (Homebrew)

```bash
# 安装所有工具
brew install ripgrep fd bat eza git-delta sd hyperfine dust duf procs bottom choose-rust xsv jq yq broot
```

### Cargo (Rust 工具)

```bash
cargo install ripgrep fd-find bat git-delta sd hyperfine dust duf procs bottom broot
```

### 检查安装状态

```bash
bash scripts/check-tools.sh
```

## 快速开始

### 基本用法

```bash
# 搜索文件内容（替代 grep）
rg "pattern" .

# 查找文件（替代 find）
fd "config"

# 查看文件（替代 cat）
bat file.py

# 列出目录（替代 ls）
eza -la

# 处理 JSON
jq '.key' file.json

# 处理 YAML
yq '.key' file.yaml
```

### Shell 别名配置

将以下内容添加到你的 `~/.bashrc` 或 `~/.zshrc`：

```bash
alias cat='bat'
alias ls='eza'
alias ll='eza -la'
alias tree='eza --tree'
alias grep='rg'
alias find='fd'
alias diff='delta'
alias du='dust'
alias df='duf'
alias ps='procs'
alias top='btm'
alias jj='jq .'
alias yy='yq .'
```

## 文件结构

```
fast-cli-skill/
├── SKILL.md                    # 主技能文件
├── README.md                   # 本文件
├── references/
│   ├── advanced.md             # 高级配置和用法
│   ├── cheatsheet.md           # 速查表
│   └── shell-config.md         # Shell 配置模板
└── scripts/
    └── check-tools.sh          # 工具安装检查脚本
```

## 使用场景

### 文件搜索

```bash
# 在 Python 文件中搜索
rg -t py "import"

# 查找最近修改的文件
fd --changed-within 1d

# 搜索并替换
sd "old" "new" file.txt
```

### 数据处理

```bash
# JSON 查询和过滤
cat data.json | jq '.items[] | select(.status == "active")'

# YAML 配置查看
cat config.yaml | yq '.services'

# CSV 统计
xsv stats file.csv
```

### 系统管理

```bash
# 查看磁盘使用
dust -n 20

# 查看进程
procs --tree

# 基准测试
hyperfine 'command1' 'command2'
```

### Git 集成

```bash
# 更好的 git diff
git config --global core.pager delta

# Git 日志查看
git log -p | delta
```

## 性能优势

| 任务 | 传统工具 | 现代工具 | 加速比 |
|------|----------|----------|--------|
| 搜索 10GB 文件 | grep: 45s | rg: 8s | 5-6x |
| 查找 1M 文件 | find: 12s | fd: 2s | 6x |
| 列出目录 | ls: 0.5s | eza: 0.1s | 5x |
| 解析 JSON | python: 2s | jq: 0.1s | 20x |

## 文档

- [SKILL.md](SKILL.md) - 主技能文档，包含所有工具的详细用法
- [references/advanced.md](references/advanced.md) - 高级配置和用法
- [references/cheatsheet.md](references/cheatsheet.md) - 快速参考速查表
- [references/shell-config.md](references/shell-config.md) - Shell 配置模板

## 何时使用传统工具

在以下情况下使用传统 GNU 工具：
- 在没有这些工具的最小/嵌入式系统上工作
- 脚本必须移植到没有这些工具的系统
- 现代替代工具不支持的特定 GNU 工具标志
- 用户明确要求使用传统工具

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License
