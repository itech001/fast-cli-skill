#!/bin/bash
# 自动安装缺失的快速 CLI 工具
# 支持 macOS 和 Linux (Debian/Ubuntu, Fedora/RHEL, Arch)

set -e

# 颜色
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 日志函数
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            echo "debian"
        elif [ -f /etc/fedora-release ]; then
            echo "fedora"
        elif [ -f /etc/arch-release ]; then
            echo "arch"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

# 检测包管理器
detect_package_manager() {
    local os=$1
    case $os in
        macos) echo "brew" ;;
        debian) echo "apt" ;;
        fedora) echo "dnf" ;;
        arch) echo "pacman" ;;
        *) echo "unknown" ;;
    esac
}

# 检查命令是否存在
command_exists() {
    command -v "$1" &> /dev/null
}

# 安装 Homebrew (macOS)
install_homebrew() {
    if command_exists brew; then
        return 0
    fi
    info "安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# 安装 Cargo/Rust
install_cargo() {
    if command_exists cargo; then
        return 0
    fi
    info "安装 Rust/Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
}

# 通过包管理器安装
install_via_package_manager() {
    local tool=$1
    local pkg_name=$2
    local os=$3
    local pm=$4

    case $pm in
        brew)
            info "通过 Homebrew 安装 $tool..."
            brew install "$pkg_name"
            ;;
        apt)
            info "通过 apt 安装 $tool..."
            sudo apt-get update -qq
            sudo apt-get install -y -qq "$pkg_name"
            ;;
        dnf)
            info "通过 dnf 安装 $tool..."
            sudo dnf install -y "$pkg_name"
            ;;
        pacman)
            info "通过 pacman 安装 $tool..."
            sudo pacman -S --noconfirm "$pkg_name"
            ;;
        *)
            return 1
            ;;
    esac
}

# 通过 cargo 安装
install_via_cargo() {
    local tool=$1
    local crate_name=$2

    if ! command_exists cargo; then
        install_cargo
    fi

    info "通过 cargo 安装 $tool..."
    cargo install "$crate_name"
}

# 通过 GitHub release 安装二进制
install_github_binary() {
    local tool=$1
    local repo=$2
    local binary_name=$3
    local version=${4:-latest}

    info "从 GitHub 安装 $tool..."

    local os arch
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)

    case $arch in
        x86_64) arch="amd64" ;;
        aarch64|arm64) arch="aarch64" ;;
        *) error "不支持的架构: $arch"; return 1 ;;
    esac

    local url
    if [ "$version" = "latest" ]; then
        url="https://github.com/$repo/releases/latest/download/${binary_name}-${os}-${arch}.tar.gz"
    else
        url="https://github.com/$repo/releases/download/${version}/${binary_name}-${os}-${arch}.tar.gz"
    fi

    local tmp_dir
    tmp_dir=$(mktemp -d)
    curl -sL "$url" -o "$tmp_dir/$tool.tar.gz"
    tar -xzf "$tmp_dir/$tool.tar.gz" -C "$tmp_dir"
    sudo mv "$tmp_dir/$binary_name" "/usr/local/bin/$tool"
    sudo chmod +x "/usr/local/bin/$tool"
    rm -rf "$tmp_dir"
}

# 安装 jq
install_jq() {
    local os=$1 pm=$2

    case $pm in
        brew) brew install jq ;;
        apt) sudo apt-get install -y jq ;;
        dnf) sudo dnf install -y jq ;;
        pacman) sudo pacman -S --noconfirm jq ;;
        *)
            # 通用二进制安装
            info "安装 jq..."
            local os_type arch
            os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
            arch=$(uname -m)
            case $arch in
                x86_64) arch="amd64" ;;
                aarch64|arm64) arch="arm64" ;;
            esac
            sudo curl -sL "https://github.com/jqlang/jq/releases/latest/download/jq-${os_type}-${arch}" -o /usr/local/bin/jq
            sudo chmod +x /usr/local/bin/jq
            ;;
    esac
}

# 安装 yq
install_yq() {
    local os=$1 pm=$2

    case $pm in
        brew) brew install yq ;;
        apt)
            # yq 不在默认 apt 源中，使用 snap 或二进制
            info "安装 yq..."
            sudo curl -sL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" -o /usr/local/bin/yq
            sudo chmod +x /usr/local/bin/yq
            ;;
        dnf)
            info "安装 yq..."
            sudo curl -sL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" -o /usr/local/bin/yq
            sudo chmod +x /usr/local/bin/yq
            ;;
        pacman) sudo pacman -S --noconfirm yq ;;
        *)
            info "安装 yq..."
            sudo curl -sL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" -o /usr/local/bin/yq
            sudo chmod +x /usr/local/bin/yq
            ;;
    esac
}

# 工具安装配置
# 格式: command:package_name:cargo_crate:github_repo
declare -A TOOL_CONFIG=(
    ["rg"]="ripgrep:ripgrep:BurntSushi/ripgrep"
    ["fd"]="fd-find:fd-find:sharkdp/fd"
    ["bat"]="bat:bat:sharkdp/bat"
    ["eza"]="eza:eza:eza-community/eza"
    ["delta"]="git-delta:git-delta:dandavison/delta"
    ["sd"]="sd:sd:chmln/sd"
    ["hyperfine"]="hyperfine:hyperfine:sharkdp/hyperfine"
    ["dust"]="dust:du-dust:bootandy/dust"
    ["duf"]="duf:duf:muesli/duf"
    ["procs"]="procs:procs:dalance/procs"
    ["btm"]="bottom:bottom:ClementTsang/bottom"
    ["choose"]="choose-rust:choose-rust:theryangeary/choose"
    ["xsv"]="xsv:xsv:BurntSushi/xsv"
    ["broot"]="broot:broot:Canop/broot"
)

# 特殊包名映射（不同发行版包名不同）
get_package_name() {
    local tool=$1
    local pm=$2

    case $tool in
        fd)
            case $pm in
                apt) echo "fd-find" ;;
                *) echo "fd" ;;
            esac
            ;;
        *)
            echo "${TOOL_CONFIG[$tool]%%:*}"
            ;;
    esac
}

# 安装单个工具
install_tool() {
    local tool=$1
    local os=$2
    local pm=$3

    # jq 和 yq 特殊处理
    if [ "$tool" = "jq" ]; then
        install_jq "$os" "$pm"
        return $?
    fi
    if [ "$tool" = "yq" ]; then
        install_yq "$os" "$pm"
        return $?
    fi

    local config="${TOOL_CONFIG[$tool]}"
    local pkg_name="${config%%:*}"
    local cargo_crate
    cargo_crate=$(echo "$config" | cut -d: -f2)
    local github_repo
    github_repo=$(echo "$config" | cut -d: -f3)

    # 获取发行版特定包名
    pkg_name=$(get_package_name "$tool" "$pm")

    # 尝试通过包管理器安装
    if install_via_package_manager "$tool" "$pkg_name" "$os" "$pm"; then
        return 0
    fi

    # 尝试通过 cargo 安装
    if install_via_cargo "$tool" "$cargo_crate"; then
        return 0
    fi

    error "无法安装 $tool"
    return 1
}

# 主安装函数
main() {
    echo "=========================================="
    echo "  快速 CLI 工具自动安装脚本"
    echo "=========================================="
    echo ""

    local os pm
    os=$(detect_os)
    pm=$(detect_package_manager "$os")

    info "检测到操作系统: $os"
    info "包管理器: $pm"
    echo ""

    # 检查并安装 Homebrew (macOS)
    if [ "$os" = "macos" ] && ! command_exists brew; then
        warn "未检测到 Homebrew"
        read -p "是否安装 Homebrew? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_homebrew
        else
            error "macOS 需要 Homebrew 来安装工具"
            exit 1
        fi
    fi

    # 定义所有工具
    local all_tools=(rg fd bat eza delta sd hyperfine dust duf procs btm choose xsv jq yq broot)

    local installed=()
    local to_install=()

    # 检查哪些工具需要安装
    for tool in "${all_tools[@]}"; do
        if command_exists "$tool"; then
            installed+=("$tool")
        else
            to_install+=("$tool")
        fi
    done

    # 显示已安装的工具
    if [ ${#installed[@]} -gt 0 ]; then
        success "已安装 (${#installed[@]}): ${installed[*]}"
    fi

    # 如果没有需要安装的工具
    if [ ${#to_install[@]} -eq 0 ]; then
        echo ""
        success "所有工具都已安装！"
        exit 0
    fi

    # 显示需要安装的工具
    echo ""
    info "需要安装 (${#to_install[@]}): ${to_install[*]}"
    echo ""

    # 确认安装
    read -p "是否安装以上工具? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        info "已取消安装"
        exit 0
    fi

    echo ""

    # 安装工具
    local success_count=0
    local fail_count=0
    local failed_tools=()

    for tool in "${to_install[@]}"; do
        echo "------------------------------------------"
        if install_tool "$tool" "$os" "$pm"; then
            success "$tool 安装成功"
            ((success_count++))
        else
            error "$tool 安装失败"
            failed_tools+=("$tool")
            ((fail_count++))
        fi
    done

    # 显示结果
    echo ""
    echo "=========================================="
    echo "  安装完成"
    echo "=========================================="
    echo ""
    success "成功安装: $success_count 个工具"

    if [ $fail_count -gt 0 ]; then
        error "安装失败: $fail_count 个工具"
        echo "  失败的工具: ${failed_tools[*]}"
        echo ""
        echo "请尝试手动安装:"
        for tool in "${failed_tools[@]}"; do
            echo "  - $tool"
        done
    fi

    echo ""
    info "运行 'bash scripts/check-tools.sh' 验证安装"
}

# 如果直接运行脚本
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
