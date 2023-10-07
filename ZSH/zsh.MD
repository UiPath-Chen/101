### Install zsh
```bash
apt install -y zsh

cat /etc/shells |grep zsh

chsh -s /bin/zsh
```

### Install oh-my-zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 或
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

### Plugins:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

> 修改配置
```bash
plugins=(
    git
    # other plugins...
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
)
```

### Install oh-my-posh

```bash
nano ~/.zshrc
# ZSH_THEME="robbyrussell"

plugins=(
    git
    # other plugins
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
)

# 配置主题
~/.oh-my-zsh/themes/keystone_bubbles.omp.json

# 启动主题
nano .oh-my-zsh/oh-my-zsh.sh

if [[ -n "$ZSH_THEME" ]]; then
  if is_theme "$ZSH_CUSTOM" "$ZSH_THEME"; then
    source "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme"
  elif is_theme "$ZSH_CUSTOM/themes" "$ZSH_THEME"; then
    source "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme"
  elif is_theme "$ZSH/themes" "$ZSH_THEME"; then
    source "$ZSH/themes/$ZSH_THEME.zsh-theme"
  else
    echo "[oh-my-zsh] theme '$ZSH_THEME' not found"
  fi
# 添加以下三行
else
    echo "config theme by oh-my-posh"
    eval "$(oh-my-posh --config ~/.oh-my-zsh/themes/keystone_bubbles.omp.json init zsh)"
fi

# 更新
exec zsh
```