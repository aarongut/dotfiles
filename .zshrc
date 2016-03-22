autoload -U colors && colors

source ~/.git-prompt.sh

if [[ -f .zshrc_local ]]
then
  source .zshrc_local
else
fi

export PATH=$PATH:/opt/cc0/bin:~/bin:/opt/android-studio/bin:/opt/smlnj/bin
export EDITOR=vim
export CLICOLOR=1

export MAIL=/var/spool/mail/amgutier

export LSCOLORS=DxGxcxdxCxegedabagacad
export TERM=xterm-256color #256 color support
export LESSOPEN='|/usr/local/bin/lesspipe.sh %s'

setopt PROMPT_SUBST ;
# for git-prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCOLORHINTS=1

PS1=$'\n╭%{$fg[yellow]%}$(__git_ps1 "(%s)")%{$fg[green]%}[%~]%{$reset_color%}\n╰%{$fg[cyan]%}%n%{$fg[yellow]%}@%{%F{214}%}%m%f%{$reset_color%}%# '

alias cdg='. cdg'
alias coin='rlwrap coin' # by-setup-c0
alias ed='ed -p:'
alias fuck='sudo $(history -p \!\!)'
alias grep='grep --color=auto'
alias hidden='ls -a | grep "^\..*"'
alias killz='killall -9 '
alias m='ncmpcpp'
alias math='rlwrap MathKernel'
alias ocaml='rlwrap ocaml'
alias ocamldebug='rlwrap ocamldebug'
alias rm='rm -i'
alias shell='ps -p $$ -o comm='
alias sml='rlwrap sml'
alias style='clang-format-3.5 -style=Google'
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

# OPAM configuration
. /home/amgutier/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
eval `opam config env`

export SMLNJ_HOME=/usr

# The following lines were added by compinstall
zstyle :compinstall filename '/home/amgutier/.zshrc'

autoload -Uz compinit
compinit

setopt completeinword
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=250000
SAVEHIST=250000
setopt appendhistory autocd
bindkey -v
bindkey "^R" history-incremental-search-backward
# End of lines configured by zsh-newuser-install
