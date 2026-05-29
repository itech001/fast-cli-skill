---
name: fast-cli-skill
description: Use this skill when working with modern fast command-line tools that replace traditional GNU/Unix utilities. This includes ripgrep (rg), fd, bat, eza, delta, sd, hyperfine, dust, duf, procs, bottom, choose, xsv, jq, yq, and more. Trigger when user mentions searching files, finding files, viewing file contents, listing directories, benchmarking commands, disk usage, process management, JSON/YAML processing, or any task traditionally done with grep, find, cat, ls, sed, cut, du, df, ps, top, jq, yq, etc. Always prefer these faster, more user-friendly alternatives.
---

# 现代快速 CLI 工具指南

## 概述

本指南涵盖替代传统 GNU/Unix 命令行工具的现代工具。这些工具更快、更友好、提供更好的默认设置。

## 安装

```bash
# macOS (Homebrew)
brew install ripgrep fd bat eza git-delta sd hyperfine dust duf procs bottom broot choose-rust xsv jq yq

# Cargo (Rust 工具)
cargo install ripgrep fd-find bat git-delta sd hyperfine dust duf procs bottom broot
```

## 工具映射

| 现代工具 | 替代 | 安装名 |
|----------|------|--------|
| `rg` | `grep` | ripgrep |
| `fd` | `find` | fd-find |
| `bat` | `cat` | bat |
| `eza` | `ls` | eza |
| `delta` | `diff` | git-delta |
| `sd` | `sed` | sd |
| `hyperfine` | `time` | hyperfine |
| `dust` | `du` | dust |
| `duf` | `df` | duf |
| `procs` | `ps` | procs |
| `btm` | `top` | bottom |
| `choose` | `cut` | choose-rust |
| `xsv` | `csvtool` | xsv |
| `broot` | `tree` | broot |
| `zoxide` | `cd` | zoxide |
| `jq` | - | jq |
| `yq` | - | yq |

## 快速参考

### ripgrep (rg) - 搜索文件内容

```bash
# 基本搜索（默认递归）
rg "pattern" .

# 不区分大小写
rg -i "pattern"

# 搜索特定文件类型
rg -t py "import"
rg -t js "function"

# 显示上下文行
rg -C 3 "error"  # 前后各3行

# 搜索隐藏文件
rg --hidden "pattern"

# 排除目录
rg --glob '!node_modules' "pattern"

# 固定字符串（非正则）
rg -F "exact.match"

# 计数匹配
rg -c "pattern"

# 仅显示文件名
rg -l "pattern"

# 替换（预览）
rg "old" --replace "new"

# JSON 输出
rg --json "pattern"
```

### fd - 查找文件

```bash
# 基本搜索
fd "pattern"

# 搜索特定扩展名
fd -e py

# 在特定目录搜索
fd "config" /etc

# 不区分大小写
fd -i "readme"

# 对结果执行命令
fd -e py -x python -m py_compile {}

# 显示隐藏文件
fd -H

# 排除模式
fd -E "*.log" -E "node_modules"

# 最大深度
fd --max-depth 3 "pattern"

# 全路径匹配
fd -p ".*config.*"

# 列出详细信息
fd -l "pattern"
```

### bat - 查看文件内容

```bash
# 查看文件（带语法高亮）
bat file.py

# 查看多个文件
bat file1.py file2.js

# 显示行号
bat -n file.py

# 仅显示特定行
bat --line-range 10:20 file.py

# 纯文本模式（无装饰）
bat -p file.py

# 显示非打印字符
bat -A file.py

# 强制语言
bat -l json file.txt

# 差异模式
bat --diff file1.py file2.py
```

### eza - 列出目录内容

```bash
# 基本列表
eza

# 长格式详情
eza -l

# 显示隐藏文件
eza -la

# 树形视图
eza --tree

# 限制树深度
eza --tree --level=2

# 按大小排序
eza -l --sort=size

# 按修改时间排序
eza -l --sort=modified

# 显示 git 状态
eza -l --git

# 图标（终端支持时）
eza --icons

# 目录优先
eza --group-directories-first
```

### delta - 查看差异

```bash
# 与 git 配合
git diff | delta

# 并排对比
delta -s file1 file2

# 显示行号
delta -n file1 file2

# 在 .gitconfig 中配置
[core]
    pager = delta
[delta]
    navigate = true
    line-numbers = true
    side-by-side = true
```

### sd - 搜索和替换

```bash
# 基本替换
sd "old" "new" file.txt

# 正则捕获组
sd '(\d+)' 'num_$1' file.txt

# 就地编辑
sd -i "old" "new" file.txt

# 预览（不修改文件）
sd "pattern" "replacement" file.txt

# 管道输入
echo "hello world" | sd "world" "rust"
```

### hyperfine - 命令基准测试

```bash
# 基本基准测试
hyperfine 'command1' 'command2'

# 预热运行
hyperfine --warmup 3 'command'

# 多次运行
hyperfine -r 10 'command'

# 导出结果
hyperfine --export-json results.json 'command'

# 参数扫描比较
hyperfine 'sleep 0.{1..5}'

# 设置命令
hyperfine --setup 'make clean' 'make'
```

### dust - 磁盘使用

```bash
# 显示目录大小
dust

# 前20个最大目录
dust -n 20

# 显示表面大小
dust -s

# 反向排序（最小优先）
dust -r

# 深度限制
dust -d 3

# 特定目录
dust /path/to/dir
```

### duf - 磁盘空间

```bash
# 显示所有文件系统
duf

# 特定路径
duf /home /tmp

# 按大小排序
duf --sort size

# 仅显示本地设备
duf --only local

# JSON 输出
duf --json
```

### procs - 进程查看器

```bash
# 列出所有进程
procs

# 按名称搜索
procs nginx

# 按 CPU 排序
procs --sortd cpu

# 按内存排序
procs --sortd mem

# 树形视图
procs --tree

# 监视模式
procs --watch
```

### bottom (btm) - 系统监控

```bash
# 启动交互式监控
btm

# 基本模式（无图表）
btm --basic

# 显示特定组件
btm --disable_cursor
```

### choose - 列选择

```bash
# 选择列（从0开始）
choose 0 2 4

# 列范围
choose 0:3

# 负索引（从末尾）
choose -1

# 自定义分隔符
choose -d ',' 0 1

# 替换分隔符
choose -d ',' -o ' | ' 0 1
```

### xsv - CSV 处理

```bash
# 查看 CSV
xsv table file.csv

# 选择列
xsv select 1,3 file.csv

# 过滤行
xsv search "pattern" file.csv

# 按列排序
xsv sort -s 2 file.csv

# 统计信息
xsv stats file.csv

# 连接两个 CSV
xsv join col1 file1.csv col2 file2.csv

# 计数行
xsv count file.csv
```

### jq - JSON 处理

```bash
# 基本查询
cat file.json | jq '.key'

# 嵌套访问
cat file.json | jq '.users[0].name'

# 过滤数组
cat file.json | jq '.items[] | select(.status == "active")'

# 提取多个字段
cat file.json | jq '{name: .name, age: .age}'

# 数组操作
cat file.json | jq '.items | length'
cat file.json | jq '.items | map(.name)'
cat file.json | jq '.items | sort_by(.date)'

# 条件过滤
cat file.json | jq '.items[] | select(.price > 100)'

# 格式化输出
cat file.json | jq '.'

# 紧凑输出
cat file.json | jq -c '.'

# 创建 JSON
echo '{"name": "test"}' | jq '.'

# 修改字段
cat file.json | jq '.name = "new_name"'

# 删除字段
cat file.json | jq 'del(.password)'

# 合并对象
cat file.json | jq '. + {"new_key": "value"}'

# 转换为 CSV
cat file.json | jq -r '.items[] | [.name, .age] | @csv'

# 转换为 TSV
cat file.json | jq -r '.items[] | [.name, .age] | @tsv'

# 从文件读取
jq '.key' file.json

# 原地编辑（需要临时文件）
jq '.key = "value"' file.json > tmp.json && mv tmp.json file.json
```

### yq - YAML/TOML 处理

```bash
# 基本查询
cat file.yaml | yq '.key'

# 嵌套访问
cat file.yaml | yq '.users[0].name'

# 过滤数组
cat file.yaml | yq '.items[] | select(.status == "active")'

# 提取多个字段
cat file.yaml | yq '{name: .name, age: .age}'

# 数组操作
cat file.yaml | yq '.items | length'
cat file.yaml | yq '.items | map(.name)'

# 条件过滤
cat file.yaml | yq '.items[] | select(.price > 100)'

# 格式化输出
cat file.yaml | yq -P '.'  # 美化 YAML

# JSON 转 YAML
cat file.json | yq -P '.' 

# YAML 转 JSON
cat file.yaml | yq -o json '.'

# 修改字段
cat file.yaml | yq '.name = "new_name"'

# 删除字段
cat file.yaml | yq 'del(.password)'

# 合并对象
cat file.yaml | yq '. + {"new_key": "value"}'

# 从文件读取
yq '.key' file.yaml

# 原地编辑
yq -i '.key = "value"' file.yaml

# TOML 处理
cat file.toml | yq -o json '.'  # TOML 转 JSON

# 多文档 YAML
cat multi.yaml | yq 'select(.kind == "Deployment")'

# 创建 YAML
echo 'name: test' | yq '.'
```

## Shell 别名

添加到 `~/.bashrc` 或 `~/.zshrc`：

```bash
# 核心替换
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

# Git 别名
alias gd='git diff | delta'
alias gl='git log | delta'

# 有用组合
alias fdr='fd -t f | rg'  # 查找文件然后搜索
alias rgf='rg -l'         # 仅显示匹配的文件名
alias jj='jq .'           # 格式化 JSON
alias yy='yq .'           # 格式化 YAML
```

## 集成示例

### 与 Git 配合

```bash
# 更好的 git diff
git config --global core.pager delta
git config --global delta.navigate true
git config --global delta.line-numbers true

# Git grep 配合 ripgrep
git grep -p "pattern" | delta
```

### 与 fzf 配合

```bash
# 用 fd 查找文件，用 bat 预览
fzf --preview 'bat --color=always {}'

# 查找并编辑
fd -t f | fzf --preview 'bat --color=always {}' | xargs $EDITOR
```

### 与 xargs 配合

```bash
# 查找并处理
fd -e py | xargs rg "pattern"

# 查找并删除
fd -e tmp | xargs rm
```

### JSON/YAML 管道

```bash
# 搜索 JSON 文件中的内容
fd -e json | xargs jq '.name'

# 搜索 YAML 文件
fd -e yaml -e yml | xargs yq '.metadata.name'

# JSON 转 YAML
cat config.json | yq -P '.' > config.yaml

# YAML 转 JSON
cat config.yaml | yq -o json '.' > config.json

# 提取所有 JSON 文件的特定字段
fd -e json -x jq -r '.name // empty' {}

# 批量修改 YAML 文件
fd -e yaml -x yq -i '.spec.replicas = 3' {}
```

## 性能比较

| 任务 | 传统工具 | 现代工具 | 加速 |
|------|----------|----------|------|
| 搜索 10GB 文件 | grep: 45s | rg: 8s | 5-6x |
| 查找 1M 文件 | find: 12s | fd: 2s | 6x |
| 列出目录 | ls: 0.5s | eza: 0.1s | 5x |
| 差异大文件 | diff: 3s | delta: 0.5s | 6x |
| 解析 JSON | python: 2s | jq: 0.1s | 20x |

## 提示

1. **默认使用现代工具**：始终优先使用 `rg` 而非 `grep`，`fd` 而非 `find` 等
2. **使用内置帮助**：所有工具支持 `--help` 并提供清晰文档
3. **组合工具**：这些工具在管道中配合得很好
4. **检查可用性**：用 `which <tool>` 验证工具是否已安装
5. **尊重用户配置**：部分工具有配置文件（如 `~/.config/bat/config`）

## 何时使用传统工具

在以下情况下使用传统 GNU 工具：
- 在没有这些工具的最小/嵌入式系统上工作
- 脚本必须移植到没有这些工具的系统
- 现代替代工具不支持的特定 GNU 工具标志
- 用户明确要求使用传统工具
