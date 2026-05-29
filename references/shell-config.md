# 快速 CLI 工具 - Shell 配置
# 将以下内容添加到你的 ~/.bashrc、~/.zshrc 或 ~/.config/fish/config.fish

# ===== Bash/Zsh =====

# 核心工具别名
alias cat='bat'
alias ls='eza'
alias ll='eza -la'
alias la='eza -a'
alias tree='eza --tree'
alias grep='rg'
alias find='fd'
alias diff='delta'
alias du='dust'
alias df='duf'
alias ps='procs'
alias top='btm'

# JSON/YAML 工具别名
alias jj='jq .'
alias yy='yq .'

# Git 别名配合 delta
alias gd='git diff | delta'
alias gl='git log | delta'
alias gs='git status'

# 环境变量
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export BAT_THEME="Dracula"  # 或 "TwoDark", "Monokai Extended" 等
export EZA_COLORS="da=37:di=34"

# 使用 bat 作为 man 分页器
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# 使用 delta 作为 git 分页器
export GIT_PAGER="delta"

# jq 颜色配置
export JQ_COLORS="2;30:0;39:0;39:0;39:0;32:1;39:1;39"

# ===== Fish Shell =====

# 核心工具别名 (Fish)
alias cat 'bat'
alias ls 'eza'
alias ll 'eza -la'
alias la 'eza -a'
alias tree 'eza --tree'
alias grep 'rg'
alias find 'fd'
alias diff 'delta'
alias du 'dust'
alias df 'duf'
alias ps 'procs'
alias top 'btm'

# JSON/YAML 工具别名 (Fish)
alias jj 'jq .'
alias yy 'yq .'

# Git 别名配合 delta (Fish)
alias gd 'git diff | delta'
alias gl 'git log | delta'
alias gs 'git status'

# 环境变量 (Fish)
set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
set -gx BAT_THEME "Dracula"
set -gx EZA_COLORS "da=37:di=34"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx GIT_PAGER "delta"
set -gx JQ_COLORS "2;30:0;39:0;39:0;39:0;32:1;39:1;39"

# ===== ripgrep 配置 (~/.ripgreprc) =====
# 创建此文件：
# --smart-case
# --hidden
# --glob=!.git
# --glob=!node_modules
# --glob=!target
# --glob=!__pycache__

# ===== bat 配置 (~/.config/bat/config) =====
# --theme="Dracula"
# --style="numbers,changes,header"
# --italic-text=always

# ===== delta 配置 (~/.gitconfig) =====
# [core]
#     pager = delta
# [delta]
#     navigate = true
#     line-numbers = true
#     side-by-side = true
#     syntax-theme = "Dracula"
# [delta "navigate"]
#     dark = true
#     syntax-theme = "Dracula"

# ===== eza 配置 (~/.config/eza/theme.yml) =====
# colourful: true
# filekinds:
#   normal: {foreground: "White"}
#   directory: {foreground: "Blue"}
#   symlink: {foreground: "Cyan"}
#   executable: {foreground: "Green"}

# ===== fd 配置 (~/.config/fd/ignore) =====
# .git
# node_modules
# target
# *.pyc
# __pycache__
# .DS_Store

# ===== 有用函数 =====

# 查找并预览文件（配合 bat）
fzf_preview() {
    if command -v fzf &> /dev/null; then
        fd -t f | fzf --preview 'bat --color=always --style=numbers --line-range :500 {}'
    else
        echo "fzf 未安装"
    fi
}

# 跨文件搜索替换
rg_replace() {
    if [ $# -lt 2 ]; then
        echo "用法: rg_replace <旧模式> <新模式> [文件类型]"
        return 1
    fi
    local old=$1
    local new=$2
    local type=${3:-}
    
    if [ -n "$type" ]; then
        fd -e "$type" -x sd "$old" "$new" {}
    else
        fd -t f -x sd "$old" "$new" {}
    fi
}

# 显示排序后的目录大小
du_sorted() {
    dust -n ${1:-20}
}

# 查找大文件
find_large() {
    local size=${1:-100M}
    fd -t f --size +"$size" -l | sort -k5 -h
}

# Git 差异带上下文
gdiff() {
    git diff --color=always "$@" | delta
}

# 进程搜索
ps_search() {
    if [ $# -eq 0 ]; then
        procs
    else
        procs "$1"
    fi
}

# CSV 快速查看
csv_view() {
    if [ $# -eq 0 ]; then
        echo "用法: csv_view <文件.csv> [行数]"
        return 1
    fi
    local file=$1
    local rows=${2:-20}
    xsv table "$file" | head -n "$rows"
}

# CSV 统计
csv_stats() {
    if [ $# -eq 0 ]; then
        echo "用法: csv_stats <文件.csv>"
        return 1
    fi
    xsv stats "$1" | xsv table
}

# 基准比较
bench_compare() {
    if [ $# -lt 2 ]; then
        echo "用法: bench_compare <命令1> <命令2> [运行次数]"
        return 1
    fi
    local runs=${3:-10}
    hyperfine -r "$runs" "$1" "$2"
}

# 磁盘使用报告
disk_report() {
    echo "=== 目录大小 ==="
    dust -n 10
    echo ""
    echo "=== 文件系统使用 ==="
    duf --only local
    echo ""
    echo "=== 大文件 ==="
    fd -t f --size +100M -l | head -20
}

# 进程和内存报告
proc_report() {
    echo "=== 内存 Top 进程 ==="
    procs --sortd mem | head -20
    echo ""
    echo "=== CPU Top 进程 ==="
    procs --sortd cpu | head -20
}

# JSON 格式化
json_format() {
    if [ $# -eq 0 ]; then
        echo "用法: json_format <文件.json>"
        return 1
    fi
    jq '.' "$1"
}

# JSON 提取字段
json_get() {
    if [ $# -lt 2 ]; then
        echo "用法: json_get <文件.json> <字段路径>"
        return 1
    fi
    jq "$2" "$1"
}

# YAML 格式化
yaml_format() {
    if [ $# -eq 0 ]; then
        echo "用法: yaml_format <文件.yaml>"
        return 1
    fi
    yq '.' "$1"
}

# YAML 提取字段
yaml_get() {
    if [ $# -lt 2 ]; then
        echo "用法: yaml_get <文件.yaml> <字段路径>"
        return 1
    fi
    yq "$2" "$1"
}

# JSON 转 YAML
json2yaml() {
    if [ $# -eq 0 ]; then
        echo "用法: json2yaml <文件.json> [输出文件.yaml]"
        return 1
    fi
    local output=${2:-"${1%.json}.yaml"}
    yq -P '.' "$1" > "$output"
    echo "已转换: $output"
}

# YAML 转 JSON
yaml2json() {
    if [ $# -eq 0 ]; then
        echo "用法: yaml2json <文件.yaml> [输出文件.json]"
        return 1
    fi
    local output=${2:-"${1%.yaml}.json"}
    yq -o json '.' "$1" > "$output"
    echo "已转换: $output"
}

# 批量 JSON 处理
json_batch() {
    if [ $# -lt 2 ]; then
        echo "用法: json_batch <jq表达式> [目录]"
        return 1
    fi
    local dir=${2:-.}
    fd -e json -t f "$dir" | while read -r file; do
        echo "处理: $file"
        jq "$1" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    done
}

# 批量 YAML 处理
yaml_batch() {
    if [ $# -lt 2 ]; then
        echo "用法: yaml_batch <yq表达式> [目录]"
        return 1
    fi
    local dir=${2:-.}
    fd -e yaml -e yml -t f "$dir" | while read -r file; do
        echo "处理: $file"
        yq -i "$1" "$file"
    done
}
