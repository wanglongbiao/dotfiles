# ─── oh-my-zsh ───
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true"
ZSH_THEME="agnoster"  # 需 Powerline 字体
plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker docker-compose)
source $ZSH/oh-my-zsh.sh

# ─── 键位 ───
bindkey ',' autosuggest-accept  # 逗号接受 autosuggestions

# ─── PATH ───
export PATH="$PATH:/usr/sbin"
[ -d "$HOME/.local/bin" ]    && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"

# ─── nvm ───
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ─── 别名（与 bash 共用） ───
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

# ─── 机器本地配置（不入仓库） ───
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
