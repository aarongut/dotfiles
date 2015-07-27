source ~/.git-prompt.sh

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

export PATH=$PATH:/opt/cc0/bin:~/bin:/opt/android-studio/bin
export EDITOR=vim
export CLICOLOR=1
export HISTCONTROL=ignoreboth
export HISTSIZE=250000
export HISTFILESIZE=250000
export LSCOLORS=DxGxcxdxCxegedabagacad
export TERM=xterm-256color #256 color support
export LESSOPEN='|/usr/local/bin/lesspipe.sh %s'

# for git-prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCOLORHINTS=1

# Prompt differs if SSH'ed or not
PS1='\n╭\[\e[1;33m\]$(__git_ps1 "(%s)")\[\e[1;32m\][\w]\[\033[0m\]\n╰\[\033[1;36m\]\u\[\033[1;33m\]@\[\e[38;5;214m\]\h\[\033[1;33m\]\$ \[\033[0m\]'

export XLISPPATH=/etc/nyquist/lib:/etc/nyquist/runtime

# Enable color support of ls and also add handy aliases
# Mac OS doesn't support --color flag for ls, needs -G instead.
if [[ `uname` = "Darwin" ]]
then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi

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
alias rm='rm -i'
alias shell='ps -p $$ -o comm='
alias sml='rlwrap sml'
alias style='clang-format-3.5 -style=Google'
alias telnet='rlwrap telnet'

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind "set completion-ignore-case on"

# Turn off the ability for other people to message your terminal using wall
mesg n

# OPAM configuration
. /home/amgutier/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
