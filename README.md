# dotfiles

裸 Linux 一行命令复刻我的终端环境：

- **vim**：基础键位（J/K 切换 tab，q 保存退出，F2 粘贴模式等）
- **tmux**：vi 模式 + 鼠标 + tmux-resurrect + tmux-continuum
- **aliases**：apt / docker / tmux 常用快捷命令
- **zsh + oh-my-zsh**：agnoster 主题 + zsh-autosuggestions + zsh-syntax-highlighting

---

## 一行命令

```sh
curl -fsSL https://raw.githubusercontent.com/wanglongbiao/dotfiles/main/install.sh | bash

# on the server
# git@github.com:wanglongbiao/dotfiles.git ~/.dotfiles
```

脚本**完全幂等**，可以反复执行。

---

## 环境变量

| 变量 | 默认值 | 说明 |
|---|---|---|
| `DOTFILES_REPO`    | `wanglongbiao/dotfiles`   | 仓库 `owner/name` |
| `DOTFILES_BRANCH`  | `main`                    | 分支 |
| `DOTFILES_DIR`     | `$HOME/.dotfiles`         | 本地克隆目录 |
| `DOTFILES_NO_CHSH` | （不设）                  | 设为 `1` 跳过 `chsh -s zsh` |
| `DOTFILES_NO_OMZ`  | （不设）                  | 设为 `1` 跳过 oh-my-zsh 及插件 |

例如试用一下我的配置但不修改默认 shell：

```sh
curl -fsSL https://raw.githubusercontent.com/wanglongbiao/dotfiles/main/install.sh | DOTFILES_NO_CHSH=1 bash
```

---

## 它做了什么

1. 检查 `git` / `curl`（必备），`zsh` / `vim` / `tmux`（缺失给警告但不退出）
2. clone / pull 本仓库到 `~/.dotfiles`
3. 软链：
   - `~/.dotfiles/vimrc`        → `~/.vimrc`
   - `~/.dotfiles/tmux.conf`    → `~/.tmux.conf`
   - `~/.dotfiles/bash_aliases` → `~/.bash_aliases`
   - `~/.dotfiles/zshrc`        → `~/.zshrc`
4. clone tmux 插件到 `~/.tmux/plugins/{tmux-resurrect,tmux-continuum}`
5. 装 oh-my-zsh（已装则跳过）和 `zsh-autosuggestions` / `zsh-syntax-highlighting`
6. `chsh -s $(which zsh)`（如果有 sudo 或非交互可写）

**安全**：所有原有同名文件如果不是软链，都会被备份为 `*.bak.<timestamp>`，绝不直接覆盖。

---

## 机器特定的配置怎么写

机器专属的 PATH、token、私有 alias 等**不要**写进本仓库，写到：

```sh
~/.zshrc.local
```

`zshrc` 末尾会自动 source 它。这个文件不会被 dotfiles 追踪。

---

## 卸载 / 回滚

```sh
rm -f ~/.vimrc ~/.tmux.conf ~/.bash_aliases ~/.zshrc
# 找出之前的备份，按需还原
ls -lt ~/.*.bak.* 2>/dev/null
# 删除本地克隆
rm -rf ~/.dotfiles
```

oh-my-zsh 自带卸载：`uninstall_oh_my_zsh`
