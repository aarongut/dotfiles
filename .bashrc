# This includes the bashrc distributed by 98-172 
# Great Practical Ideas for Computer Scientists
source ~/.bashrc_gpi

# Add your own changes below...
export PATH=/nyquist:$PATH:/cc0/bin:~/bin
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad
export TERM=xterm-256color #256 color support
export LESSOPEN='|/usr/local/bin/lesspipe.sh %s'
PS1="\n╭\[\033[32m\][\w]\[\033[0m\]\n╰\[\033[1;36m\]\u\[\033[1;33m\]\$ \[\033[0m\]"

export XLISPPATH=/nyquist/lib:/nyquist/runtime

alias coin='rlwrap coin' # by-setup-c0
#alias kinit='kinit.sh'
alias ed='ed -p:'
alias sml='rlwrap sml'
alias g='google-chrome-unstable'

alias ocaml='rlwrap ocaml'


# OPAM configuration
. /home/amgutier/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
