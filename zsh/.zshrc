source /usr/share/zsh/share/antigen.zsh
antigen bundle esc/conda-zsh-completion
antigen apply

# Path to your oh-my-zsh installation.
export ZSH="/usr/share/oh-my-zsh"
alias ohmyzsh="mate /usr/share/oh-my-zsh"
ZSH_THEME="agnoster"
source $ZSH/oh-my-zsh.sh

plugins=(git)

# personal env
export NVIMRC="$HOME/.config/nvim/init.vim"
export ZSHRC="$HOME/.zshrc"
# export default editor and visual
export VISUAL=nvim
export EDITOR=nvim

# personal alias
alias sz="source $ZSHRC"
alias ez="n $ZSHRC"
alias gs="git status"
alias gl="git log"
alias ga="git add"
alias ga.="git add ."
alias gc="git commit -m"
alias gca="git commit --amend"
alias gp="git push"
alias gg="git log --all --decorate --oneline --graph"
alias ggg="git log --graph --pretty=format:'%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn <%ce>%Creset %s'"
alias gd="git diff"
alias gk="git checkout"
alias c="xclip"
alias p="xclip -o"
alias n="nvim"
alias N="sudo nvim"
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias cl="clear"
alias cd.="cd .."
alias d.="nohup dolphin . &"

# fzf stuff
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -f -g ""'
export FZF_DEFAULT_OPTS="--reverse --inline-info --preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window='right:hidden:wrap' --bind='f2:toggle-preview'"

export PATH="$HOME/.local/bin:/opt:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# in order to have this working, run $conda config --set changeps1 false
# conda fix the agnoster path
prompt_virtualenv() {
  # Get the name of the virtual environment if one is active
  if [[ -n $VIRTUAL_ENV ]]; then
    local env_label=" $(basename $VIRTUAL_ENV) "
  fi

  # Get the name of the Anaconda environment if one is active
  if [[ -n $CONDA_PREFIX ]]; then
      if [[ $(basename $CONDA_PREFIX) == "miniconda3" ]]; then
        # Without this, it would display conda version
        env_label="base"
      else
        if [[ -n $env_label ]]; then
	  env_label+="+ $(basename $CONDA_PREFIX) "
	else
          local env_label=" $(basename $CONDA_PREFIX) "
        fi
      fi
  fi

  # Draw prompt segment if a virtual/conda environment is active
  if [[ -n $env_label ]]; then
    color=cyan
    prompt_segment $color $PRIMARY_FG
    print -Pn $env_label
  fi
}

HISTSIZE=10000
HISEFILESIZE=10000

# source local definition files
source ~/.local_definitions
alias eld="n ~/.local_definitions"
