# 快速 CLI 工具 - 速查表

## 一行速查

| 任务 | 传统工具 | 现代工具 | 示例 |
|------|----------|----------|------|
| 搜索文件 | `grep -r "pattern" .` | `rg "pattern"` | `rg "TODO" -t py` |
| 查找文件 | `find . -name "*.py"` | `fd -e py` | `fd "config" -e yaml` |
| 查看文件 | `cat file.txt` | `bat file.txt` | `bat -n file.py` |
| 列出文件 | `ls -la` | `eza -la` | `eza --tree --level=2` |
| 显示差异 | `diff file1 file2` | `delta file1 file2` | `git diff \| delta` |
| 替换文本 | `sed 's/old/new/g'` | `sd "old" "new"` | `sd -i "old" "new" file.txt` |
| 基准测试 | `time command` | `hyperfine 'command'` | `hyperfine -r 10 'cmd'` |
| 磁盘使用 | `du -sh *` | `dust` | `dust -n 20` |
| 磁盘空间 | `df -h` | `duf` | `duf --sort size` |
| 进程列表 | `ps aux` | `procs` | `procs --tree` |
| 系统监控 | `top` | `btm` | `btm --basic` |
| 选择列 | `cut -d',' -f1,2` | `choose 0 1` | `choose -d ',' 0 2` |
| CSV 处理 | `csvtool` | `xsv` | `xsv stats file.csv` |
| JSON 处理 | `python -m json.tool` | `jq` | `jq '.key' file.json` |
| YAML 处理 | `python -c "import yaml..."` | `yq` | `yq '.key' file.yaml` |

## 常用命令

### 搜索 (ripgrep)
```bash
rg "pattern"                    # 递归搜索
rg -i "pattern"                 # 不区分大小写
rg -t py "import"               # 搜索 Python 文件
rg -c "pattern"                 # 计数匹配
rg -l "pattern"                 # 仅显示文件名
rg --hidden "pattern"           # 包含隐藏文件
rg -g '!node_modules' "pattern" # 排除目录
```

### 查找 (fd)
```bash
fd "name"                       # 按名称查找
fd -e py                        # 按扩展名查找
fd -t f                         # 仅查找文件
fd -t d                         # 仅查找目录
fd --changed-within 1d          # 最近24小时修改
fd --size +100M                 # 大于100MB
fd -x command {}                # 对结果执行命令
```

### 查看 (bat)
```bash
bat file.txt                    # 语法高亮查看
bat -n file.txt                 # 显示行号
bat -p file.txt                 # 纯文本模式
bat --line-range 10:20 file.txt # 显示特定行
bat -l json file.txt            # 强制语言
bat --diff file1 file2          # 差异模式
```

### 列出 (eza)
```bash
eza                             # 基本列表
eza -la                         # 长格式含隐藏
eza --tree                      # 树形视图
eza --tree --level=3            # 限制树深度
eza -l --sort=size              # 按大小排序
eza -l --sort=modified          # 按修改时间排序
eza --git                       # 显示 git 状态
eza --icons                     # 显示图标
```

### 替换 (sd)
```bash
sd "old" "new" file.txt         # 替换文件内容
sd -i "old" "new" file.txt      # 就地编辑
sd '(\d+)' 'num_$1' file.txt   # 正则捕获组
echo "text" | sd "old" "new"   # 管道输入
```

### 基准测试 (hyperfine)
```bash
hyperfine 'command'             # 基本基准
hyperfine 'cmd1' 'cmd2'        # 比较命令
hyperfine -r 10 'command'      # 10次运行
hyperfine --warmup 3 'command' # 预热运行
hyperfine --export-json out.json 'command' # 导出结果
```

### 磁盘使用 (dust)
```bash
dust                            # 显示目录大小
dust -n 20                      # 前20个最大
dust -r                         # 反向排序
dust -d 3                       # 深度限制
dust --min-size 1M              # 按大小过滤
```

### 磁盘空间 (duf)
```bash
duf                             # 显示所有文件系统
duf --sort size                 # 按大小排序
duf --only local                # 仅本地设备
duf --json                      # JSON 输出
```

### 进程 (procs)
```bash
procs                           # 列出所有进程
procs nginx                     # 按名称搜索
procs --tree                    # 树形视图
procs --sortd cpu               # 按 CPU 排序
procs --sortd mem               # 按内存排序
```

### CSV (xsv)
```bash
xsv table file.csv              # 查看 CSV
xsv select 1,3 file.csv        # 选择列
xsv search "pattern" file.csv  # 搜索
xsv sort -s 2 file.csv         # 按列排序
xsv stats file.csv             # 统计信息
xsv count file.csv             # 计数行
```

### JSON (jq)
```bash
jq '.' file.json                # 格式化输出
jq '.key' file.json             # 提取字段
jq '.items[] | select(.active)' # 过滤数组
jq '.name = "new"' file.json   # 修改字段
jq -c '.' file.json             # 紧凑输出
jq -r '.items[] | @csv'        # CSV 输出
```

### YAML (yq)
```bash
yq '.' file.yaml                # 格式化输出
yq '.key' file.yaml             # 提取字段
yq -i '.replicas = 3' file.yaml # 原地编辑
yq -o json '.' file.yaml        # 转换为 JSON
yq -P '.' file.json             # JSON 转 YAML
```

## 有用组合

```bash
# 查找并预览
fd -t f | fzf --preview 'bat --color=always {}'

# 跨文件搜索替换
fd -e py -x sd "old" "new" {}

# 查找大文件并显示大小
fd -t f --size +100M -l | sort -k5 -h

# Git 日志带语法高亮
git log -p | delta

# 进程和磁盘使用
procs --sortd mem | head -20
dust -n 10

# CSV 分析管道
xsv stats file.csv | xsv table

# JSON 数据探索
cat data.json | jq '.items[] | {name, status}'

# YAML 配置查看
cat config.yaml | yq '.services'

# 搜索 JSON 文件内容
fd -e json | xargs jq '.name'

# 批量修改 YAML
fd -e yaml -x yq -i '.spec.replicas = 3' {}
```

## Shell 别名

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

## 配置文件

- ripgrep: `~/.ripgreprc` (设置 `RIPGREP_CONFIG_PATH`)
- bat: `~/.config/bat/config`
- eza: `~/.config/eza/theme.yml`
- delta: `~/.gitconfig` (在 `[delta]` 下)
- procs: `~/.config/procs/config.toml`
- fd: `~/.config/fd/ignore`
- jq: `~/.jq` (可选)
