#!/usr/bin/env bash
# 裸 Linux 一行命令初始化终端环境（vim / tmux / aliases / zsh + oh-my-zsh）
# 用法：curl -fsSL https://raw.githubusercontent.com/wanglongbiao/dotfiles/main/install.sh | bash
# 环境变量：DOTFILES_REPO  DOTFILES_BRANCH  DOTFILES_DIR  DOTFILES_NO_CHSH  DOTFILES_NO_OMZ

set -euo pipefail

REPO="${DOTFILES_REPO:-wanglongbiao/dotfiles}"
BRANCH="${DOTFILES_BRANCH:-main}"
DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
URL="https://github.com/${REPO}.git"

say()  { printf '\033[1;32m[ok]\033[0m %s\n'   "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
need() { command -v "$1" >/dev/null 2>&1; }

# 自动安装缺失软件包
pkg_install() {
    local missing=()
    for p in "$@"; do need "$p" || missing+=("$p"); done
    [ ${#missing[@]} -eq 0 ] && return
    say "安装: ${missing[*]}"
    if need apt-get; then
        sudo apt-get update -qq && sudo apt-get install -y -qq "${missing[@]}"
    elif need dnf; then
        sudo dnf install -y "${missing[@]}"
    elif need yum; then
        sudo yum install -y "${missing[@]}"
    elif need pacman; then
        sudo pacman -S --noconfirm "${missing[@]}"
    elif need apk; then
        sudo apk add "${missing[@]}"
    else
        warn "未找到包管理器，请手动安装: ${missing[*]}"
    fi
}

# 软链，目标若非软链则先备份
link() {
    if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak.$(date +%s)"; warn "备份 $2"; fi
    ln -sfn "$1" "$2"
}

# 已是 git 仓库则 pull，否则 clone
sync_repo() {
    if [ -d "$2/.git" ]; then
        git -C "$2" pull --ff-only --quiet 2>/dev/null || warn "更新 $2 失败"
    else
        git clone --depth 1 ${3:+-b "$3"} "$1" "$2"
    fi
}

pkg_install git curl zsh vim tmux htop

# 已是 git 仓库则 pull，有文件则复用，否则 clone
if [ -d "$DIR/.git" ]; then
    git -C "$DIR" pull --ff-only --quiet || warn "更新 $DIR 失败"
elif [ -f "$DIR/zshrc" ]; then
    say "复用本地 $DIR"
else
    mkdir -p "$(dirname "$DIR")"
    sync_repo "$URL" "$DIR" "$BRANCH"
fi

mkdir -p "$HOME/.claude"
link "$DIR/gitconfig"    "$HOME/.gitconfig"
link "$DIR/vimrc"        "$HOME/.vimrc"
link "$DIR/tmux.conf"    "$HOME/.tmux.conf"
link "$DIR/bash_aliases" "$HOME/.bash_aliases"
link "$DIR/CLAUDE.md"    "$HOME/.claude/CLAUDE.md"

mkdir -p "$HOME/.tmux/plugins"
sync_repo https://github.com/tmux-plugins/tmux-resurrect.git "$HOME/.tmux/plugins/tmux-resurrect" || true
sync_repo https://github.com/tmux-plugins/tmux-continuum.git "$HOME/.tmux/plugins/tmux-continuum" || true

if [ "${DOTFILES_NO_OMZ:-0}" != "1" ]; then
    export RUNZSH=no CHSH=no KEEP_ZSHRC=yes
    [ -d "$HOME/.oh-my-zsh" ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ZC="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    sync_repo https://github.com/zsh-users/zsh-autosuggestions.git     "$ZC/plugins/zsh-autosuggestions"
    sync_repo https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZC/plugins/zsh-syntax-highlighting"
    link "$DIR/zshrc" "$HOME/.zshrc"   # 必须在 omz 安装之后，否则会被覆盖
fi

if [ "${DOTFILES_NO_CHSH:-0}" != "1" ] && need zsh; then
    target="$(command -v zsh)"
    if [ "${SHELL:-}" != "$target" ]; then
        sudo chsh -s "$target" "$USER" 2>/dev/null \
            || chsh -s "$target" 2>/dev/null \
            || warn "chsh 失败，请手动: chsh -s $target"
    fi
fi

say "完成。打开新终端或执行: exec zsh"
