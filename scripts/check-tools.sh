#!/bin/bash
# 检查哪些快速 CLI 工具已安装并提供安装说明

set -e

# 颜色
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # 无颜色

# 工具列表：command:install_name:description
TOOLS=(
    "rg:ripgrep:快速递归搜索"
    "fd:fd-find:快速文件查找"
    "bat:bat:语法高亮查看"
    "eza:eza:现代 ls 替代"
    "delta:git-delta:更好的 diff 查看"
    "sd:sd:快速 sed 替代"
    "hyperfine:hyperfine:命令基准测试"
    "dust:dust:磁盘使用查看"
    "duf:duf:现代 df 替代"
    "procs:procs:现代 ps 替代"
    "btm:bottom:系统监控"
    "choose:choose-rust:列选择器"
    "xsv:xsv:CSV 处理"
    "jq:jq:JSON 处理"
    "yq:yq:YAML/TOML 处理"
    "broot:broot:树形导航"
)

check_tool() {
    local cmd=$1
    local name=$2
    local desc=$3
    
    if command -v "$cmd" &> /dev/null; then
        version=$("$cmd" --version 2>/dev/null | head -1 || echo "已安装")
        printf "${GREEN}✓${NC} %-12s %s\n" "$cmd" "$version"
        return 0
    else
        printf "${RED}✗${NC} %-12s %s\n" "$cmd" "$desc"
        return 1
    fi
}

install_instructions() {
    local cmd=$1
    local install_name=$2
    
    case $cmd in
        rg)
            echo "  brew install ripgrep"
            echo "  cargo install ripgrep"
            ;;
        fd)
            echo "  brew install fd"
            echo "  cargo install fd-find"
            ;;
        bat)
            echo "  brew install bat"
            echo "  cargo install bat"
            ;;
        eza)
            echo "  brew install eza"
            echo "  cargo install eza"
            ;;
        delta)
            echo "  brew install git-delta"
            echo "  cargo install git-delta"
            ;;
        sd)
            echo "  brew install sd"
            echo "  cargo install sd"
            ;;
        hyperfine)
            echo "  brew install hyperfine"
            echo "  cargo install hyperfine"
            ;;
        dust)
            echo "  brew install dust"
            echo "  cargo install du-dust"
            ;;
        duf)
            echo "  brew install duf"
            echo "  cargo install duf"
            ;;
        procs)
            echo "  brew install procs"
            echo "  cargo install procs"
            ;;
        btm)
            echo "  brew install bottom"
            echo "  cargo install bottom"
            ;;
        choose)
            echo "  brew install choose-rust"
            echo "  cargo install choose-rust"
            ;;
        xsv)
            echo "  brew install xsv"
            echo "  cargo install xsv"
            ;;
        jq)
            echo "  brew install jq"
            echo "  # 或从源码编译"
            ;;
        yq)
            echo "  brew install yq"
            echo "  # 或从 GitHub 下载二进制"
            ;;
        broot)
            echo "  brew install broot"
            echo "  cargo install broot"
            ;;
    esac
}

main() {
    echo "=== 快速 CLI 工具检查器 ==="
    echo ""
    
    installed=0
    missing=()
    
    for tool_info in "${TOOLS[@]}"; do
        IFS=':' read -r cmd install_name desc <<< "$tool_info"
        if check_tool "$cmd" "$install_name" "$desc"; then
            ((installed++))
        else
            missing+=("$cmd:$install_name")
        fi
    done
    
    echo ""
    echo "=== 总结 ==="
    echo "已安装: $installed/${#TOOLS[@]}"
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}缺少的工具:${NC}"
        for tool_info in "${missing[@]}"; do
            IFS=':' read -r cmd install_name <<< "$tool_info"
            echo ""
            echo "$cmd ($install_name):"
            install_instructions "$cmd" "$install_name"
        done
        
        echo ""
        echo "安装所有缺少的工具:"
        echo "  brew install ripgrep fd bat eza git-delta sd hyperfine dust duf procs bottom choose-rust xsv jq yq broot"
    else
        echo -e "${GREEN}所有工具都已安装！${NC}"
    fi
}

main "$@"
