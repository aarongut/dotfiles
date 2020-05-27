autoload -U colors && colors

source ~/.git-prompt.sh

if [[ -f ~/.zshrc_local ]]
then
  source ~/.zshrc_local
else
fi

export PATH=$PATH:~/bin
export EDITOR=nvim
export CLICOLOR=1

export MAIL=/var/spool/mail/amgutier

export LSCOLORS=DxGxcxdxCxegedabagacad
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

setopt PROMPT_SUBST ;
# for git-prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCOLORHINTS=1

PS1=$'\n╭%{$fg[yellow]%}$(__git_ps1 "(%s)")%{$fg[green]%}[%~]%{$reset_color%}\n╰%{$fg[cyan]%}%n%{$fg[yellow]%}@%{%F{214}%}%m%f%{$reset_color%}%# '

# set window title to working directory
precmd () { print -Pn "\e]0;%~\a" }

alias coin='rlwrap coin' # by-setup-c0
alias dark='export LC_LIGHT_BG='
alias ed='ed -p:'
alias grep='grep --color=auto'
alias light='export LC_LIGHT_BG=1'
alias m='ncmpcpp'
alias ocaml='rlwrap ocaml'
alias ocamldebug='rlwrap ocamldebug'
alias rm='rm -i'
alias sml='rlwrap sml'
alias telnet='rlwrap telnet'

# Enable color support of ls and also add handy aliases
# Mac OS doesn't support --color flag for ls, needs -G instead.
if [[ `uname` = "Darwin" ]]
then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi

# Turn off the ability for other people to message your terminal using wall
mesg n

# The following lines were added by compinstall
zstyle :compinstall filename ~/.zshrc

autoload -Uz compinit
compinit

setopt completeinword
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Variables for man page viewing
export HTMLPAGER=w3m

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=250000
SAVEHIST=250000
setopt appendhistory autocd
bindkey -v
bindkey "^R" history-incremental-search-backward
# End of lines configured by zsh-newuser-install
