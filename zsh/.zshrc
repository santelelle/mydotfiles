source $HOME/.antigen.zsh

antigen bundle esc/conda-zsh-completion

antigen apply

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias n="nvim"
alias N="sudo nvim"
alias r="ranger"

export PATH="$HOME/.local/bin:/opt:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias ohmyzsh="mate ~/.oh-my-zsh"

HISTSIZE=10000
HISEFILESIZE=10000

export NVIMRC="$HOME/.config/nvim/init.vim"
export ZSHRC="$HOME/.zshrc"

alias sz="source $ZSHRC"

# export default editor and visual
export VISUAL=nvim
export EDITOR=nvim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -f -g ""'
export FZF_DEFAULT_OPTS="--reverse --inline-info --preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window='right:hidden:wrap' --bind='f2:toggle-preview'"

# source local definition files
source ~/.local_definitions

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# git
alias gs="git status"
alias gl="git log"
alias ga="git add"
alias ga.="git add ."
alias gc="git commit -m"
alias gca="git commit --amend"
alias gp="git push"
