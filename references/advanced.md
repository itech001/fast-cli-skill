# 高级配置和用法

## ripgrep 高级用法

### 配置文件

创建 `~/.ripgreprc`：
```
--smart-case
--hidden
--glob=!.git
--glob=!node_modules
--glob=!target
```

设置环境变量：
```bash
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
```

### 高级模式

```bash
# 多模式搜索
rg -e "pattern1" -e "pattern2"

# 搜索并替换（带确认）
rg "old" --replace "new" -i

# 仅搜索特定文件类型
rg -t py -t js "function"

# 排除文件类型
rg -T js -T ts "pattern"

# 使用 PCRE2（高级正则）
rg -P "pattern"

# 搜索压缩文件
rg -z "pattern"

# 固定字符串多模式搜索
rg -F -f patterns.txt

# JSON 输出带统计
rg --json "pattern" | jq '.data.lines.text'
```

## fd 高级用法

### 配置文件

创建 `~/.config/fd/ignore`：
```
.git
node_modules
target
*.pyc
__pycache__
```

### 高级模式

```bash
# 查找并并行执行
fd -e py -x python -m py_compile {} 2>/dev/null

# 查找最近24小时修改的文件
fd --changed-within 1d

# 查找大于100MB的文件
fd --size +100M

# 查找空文件
fd --type empty

# 查找符号链接
fd --type l

# 查找并计数
fd -e py | wc -l

# 自定义命令
fd -e py -x sh -c 'echo "=== {} ===" && head -5 {}'
```

## bat 高级用法

### 配置文件

创建 `~/.config/bat/config`：
```
--theme="TwoDark"
--style="numbers,changes,header"
--italic-text=always
--map-syntax "*.conf:INI"
```

### 高级用法

```bash
# 自定义主题
bat --list-themes
bat --theme="Dracula" file.py

# 显示 git 修改
bat --diff file.py

# 用 bat 查看日志
tail -f /var/log/syslog | bat --paging=never -l syslog

# 作为 man 分页器
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# 显示非打印字符
bat -A file.txt

# 自定义语法高亮
bat -l sql query.txt

# 与其他工具组合
rg "pattern" | bat --paging=never
```

## eza 高级用法

### 配置

创建 `~/.config/eza/theme.yml`：
```yaml
colourful: true
filekinds:
  normal: {foreground: "White"}
  directory: {foreground: "Blue"}
  symlink: {foreground: "Cyan"}
  executable: {foreground: "Green"}
```

### 高级用法

```bash
# 详细树形带 git 状态
eza -la --tree --git-ignore --level=3

# 多条件排序
eza -l --sort=modified,name

# 显示扩展属性
eza -l@

# 自定义时间格式
eza -l --time-style=long-iso

# 图标（终端支持时）
eza --icons=always

# 文件大小颜色渐变
eza -l --color-scale
```

## delta 高级用法

### 配置

添加到 `~/.gitconfig`：
```ini
[core]
    pager = delta

[delta]
    navigate = true
    line-numbers = true
    side-by-side = true
    syntax-theme = "Dracula"
    plus-style = "syntax #003800"
    minus-style = "syntax #3f0001"
    file-style = "bold yellow ul"
    file-decoration-style = "yellow ul"

[delta "navigate"]
    dark = true
    syntax-theme = "Dracula"
```

### 高级用法

```bash
# 比较目录
delta -s dir1/ dir2/

# 与 git stash 配合
git stash show -p | delta

# 与 git log 配合
git log -p | delta

# 词级差异
delta --word-diff-regex='\w+'

# 自定义主题
delta --syntax-theme="Monokai Extended"
```

## sd 高级用法

### 高级模式

```bash
# 多次替换
sd 'pattern1' 'replacement1' file.txt && sd 'pattern2' 'replacement2' file.txt

# 前后断言
sd '(?<=prefix)pattern(?=suffix)' 'replacement' file.txt

# 非捕获组
sd '(?:group1|group2)' 'replacement' file.txt

# 不区分大小写
sd -i 'pattern' 'replacement' file.txt

# 多行替换
sd 'start\n.*?\nend' 'replacement' file.txt
```

## hyperfine 高级用法

### 高级模式

```bash
# 参数扫描
hyperfine 'sleep {1..5}'

# 设置和清理
hyperfine --setup 'make clean' --cleanup 'make clean' 'make'

# 导出多格式
hyperfine --export-json results.json --export-csv results.csv 'command'

# 统计分析
hyperfine -r 20 --warmup 5 'command'

# 与基线比较
hyperfine 'command1' 'command2' --baseline

# 自定义输出格式
hyperfine 'command' --output=pipe

# 忽略失败
hyperfine 'command' --ignore-failure
```

## dust 高级用法

### 高级用法

```bash
# 仅显示前 N 个条目
dust -n 20

# 反向排序
dust -r

# 表面大小 vs 磁盘使用
dust -s  # 表面大小
dust     # 磁盘使用

# 深度限制
dust -d 3

# 同一文件系统
dust -x  # 保持在同一文件系统

# 按大小过滤
dust --min-size 1M

# 自定义输出
dust -p  # 显示完整路径
```

## duf 高级用法

### 高级用法

```bash
# 按各种标准排序
duf --sort size
duf --sort used
duf --sort avail
duf --sort usage

# 过滤设备
duf --only local
duf --only network
duf --only special
duf --only fuse

# 隐藏特定文件系统
duf --hide-fuse
duf --hide-special
duf --hide-devtmpfs

# JSON 输出
duf --json | jq '.[] | select(.size > 1000000000)'
```

## procs 高级用法

### 配置

创建 `~/.config/procs/config.toml`：
```toml
[columns]
Pid = { header = "PID", align = "Right" }
User = { header = "User", align = "Left" }
Cpu = { header = "CPU%", align = "Right" }
Mem = { header = "MEM%", align = "Right" }
Command = { header = "Command", align = "Left" }
```

### 高级用法

```bash
# 多列排序
procs --sortd cpu --sorta pid

# 显示特定列
procs --tree

# 显示线程
procs --thread

# 带间隔的监视模式
procs --watch --watch-interval 2

# 按用户过滤
procs --user username

# 显示环境变量
procs --environment
```

## jq 高级用法

### 配置

创建 `~/.jq`（可选，用于自定义函数）：
```jq
def flatten_keys:
  to_entries | map({key: .key, value: .value}) | from_entries;
```

### 高级模式

```bash
# 复杂过滤
cat data.json | jq '.items[] | select(.status == "active" and .price > 100)'

# 嵌套修改
cat config.json | jq '.database.connection.host = "new_host"'

# 数组转换
cat data.json | jq '[.items[] | {name: .name, total: (.price * .quantity)}]'

# 条件赋值
cat data.json | jq '.items[] | if .status == "active" then .color = "green" else .color = "red" end'

# 递归搜索
cat data.json | jq '.. | .name? // empty'

# 多文件处理
jq -s '.[0] * .[1]' base.json override.json

# 流式处理（大文件）
jq --stream 'select(.[0][-1] == "name") | .[1]' large.json

# 自定义函数
jq 'def double: . * 2; .items[] | .price |= double' data.json

# CSV/TSV 输出
jq -r '.items[] | [.name, .age, .email] | @csv' data.json

# HTML 转义
jq -r '.items[] | .name | @html' data.json

# Base64 编码
echo '{"data": "hello"}' | jq -r '.data | @base64'

# Base64 解码
echo '{"data": "aGVsbG8="}' | jq -r '.data | @base64d'

# URI 编码
echo '{"url": "hello world"}' | jq -r '.url | @uri'
```

## yq 高级用法

### 配置

yq 通常不需要配置文件，支持环境变量 `YQ_OPTIONS`。

### 高级模式

```bash
# 复杂过滤
cat config.yaml | yq '.services[] | select(.name == "web")'

# 嵌套修改
cat config.yaml | yq '.database.connection.host = "new_host"'

# 数组操作
cat config.yaml | yq '.items |= map(select(.status == "active"))'

# 条件赋值
cat config.yaml | yq '.items[] | select(.status == "active") | .color = "green"'

# 递归搜索
cat config.yaml | yq '.. | .name? // empty'

# 多文档 YAML
cat multi.yaml | yq 'select(.kind == "Deployment") | .metadata.name'

# YAML 合并
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' base.yaml override.yaml

# JSON 转 YAML
cat config.json | yq -P '.' > config.yaml

# YAML 转 JSON
cat config.yaml | yq -o json '.' > config.json

# TOML 转 JSON
cat config.toml | yq -o json '.' > config.json

# 原地编辑
yq -i '.replicas = 3' deployment.yaml

# 表达式文件
cat expressions.yq | yq -e -f - config.yaml

# 创建 YAML
echo 'name: test' | yq '.items = []'

# 数组追加
yq '.items += [{"name": "new"}]' config.yaml

# 删除字段
yq 'del(.password)' config.yaml

# 重命名字段
yq '.new_name = .old_name | del(.old_name)' config.yaml

# 锚点和别名（YAML 特性）
cat config.yaml | yq '.default = &defaults {"timeout": 30} | .services.web = *defaults'
```

## 集成脚本

### 智能文件搜索

```bash
#!/bin/bash
# 搜索文件并用 bat 预览
if command -v fzf &> /dev/null; then
    fd -t f | fzf --preview 'bat --color=always --style=numbers --line-range :500 {}'
else
    fd -t f | head -50
fi
```

### Git 集成

```bash
#!/bin/bash
# 用 eza 显示更好的 git 状态
git status --porcelain | while read -r status file; do
    case $status in
        M)  echo -e "\033[33mmodified: $file\033[0m" ;;
        A)  echo -e "\033[32madded: $file\033[0m" ;;
        D)  echo -e "\033[31mdeleted: $file\033[0m" ;;
        ??) echo -e "\033[36muntracked: $file\033[0m" ;;
    esac
done
```

### 磁盘使用报告

```bash
#!/bin/bash
# 生成磁盘使用报告
echo "=== 目录大小 ==="
dust -n 10

echo ""
echo "=== 文件系统使用 ==="
duf --only local

echo ""
echo "=== 大文件 ==="
fd -t f --size +100M -l
```

### JSON/YAML 批量处理

```bash
#!/bin/bash
# 批量处理 JSON 文件
fd -e json | while read -r file; do
    echo "处理: $file"
    jq '.name = "updated"' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done

# 批量处理 YAML 文件
fd -e yaml -e yml | while read -r file; do
    echo "处理: $file"
    yq -i '.metadata.labels.env = "production"' "$file"
done
```

## 环境变量

```bash
# ripgrep 配置
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# bat 主题
export BAT_THEME="Dracula"

# eza 颜色
export EZA_COLORS="da=37:di=34"

# delta 分页器
export DELTA_PAGER="less -R"

# hyperfine 导出格式
export HYPERTHREAD_EXPORT_FORMAT="json"

# jq 颜色输出
export JQ_COLORS="2;30:0;39:0;39:0;39:0;32:1;39:1;39"

# yq 默认输出格式
export YQ_OUTPUT_FORMAT="yaml"
```

## 性能调优

### ripgrep
- 使用 `--threads N` 控制并行度
- 使用 `--mmap` 进行大文件内存映射 I/O
- 使用 `--no-ignore` 跳过 .gitignore 解析

### fd
- 使用 `--one-file-system` 保持在同一文件系统
- 使用 `--max-depth` 限制递归深度
- 使用 `--batch-size` 控制并行处理

### bat
- 使用 `--paging=never` 用于管道
- 使用 `--style=plain` 最小化输出
- 使用 `--line-range` 处理部分文件

### dust
- 使用 `--min-size` 过滤小文件
- 使用 `-n` 限制输出数量
- 使用 `-d` 控制深度

### jq
- 使用 `--stream` 处理大文件（流式）
- 使用 `-e` 设置退出状态码
- 使用 `--arg` 传递变量

### yq
- 使用 `-P` 美化 YAML 输出
- 使用 `-o json` 转换为 JSON
- 使用 `-i` 原地编辑
