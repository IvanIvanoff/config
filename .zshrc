# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/ivan/.oh-my-zsh
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:/home/ivan/.asdf/installs/elixir/1.6.4/.mix/escripts
  PATH=$PATH:~/.cargo/bin

 #Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="amuse"
#ZSH_THEME="agnoster"

HYPHEN_INSENSITIVE="true"
export UPDATE_ZSH_DAYS=5
COMPLETION_WAITING_DOTS="true"

 HIST_STAMPS="dd/mm/yyyy"

plugins=(git)

# bash completion compatibility
source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

DEFAULT_USER=ivan

rgrep()
{
  grep "${1}" ./ -rn --color
}

irgrep()
{
  grep -i "${1}" ./ -rn --color
}

replacerecur()
{
  find ./ -type f -print0 | xargs -0 sed -i "s/${1}/${2}/g"
}


function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}

# NEEDED
alias tmux='tmux -2' #start with 256 color
alias vun='vim'
alias les='less'

# Useful aliases
alias ..='cd ..'
alias ,,='cd -'
alias smi='sudo make install && sudo to64'
alias sy='sudo yum'
alias ports='netstat -tulanp'
alias rm='rm -I --preserve-root'
alias fhere="find . -name "
alias mkdir="mkdir -pv"


alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

alias maek='make'
export SSLKEYLOGFILE=~/work/ssl/sslkeylog.log

alias sanupdate='mix deps.get && cd assets/ && yarn install && cd .. && cd app/ && yarn install && cd ..'


. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash


vimgitshow() { git show "$1" | vim - "+set filetype=${1##*.}"; }
# Git aliases
alias g='git'
alias gs='git status'
alias gcm='git checkout master'
alias exformat='git diff master --name-only | grep "ex$\|exs$" | xargs mix format'

# Elixir stuff
alias ectomigrate='mix ecto.migrate && MIX_ENV=test mix ecto.migrate'
alias im='iex --erl "-kernel shell_history enabled" -S mix'
alias imps='iex --erl "-kernel shell_history enabled" -S mix phx.server'
alias iex='iex --erl "-kernel shell_history enabled"'
alias mt='mix test'
mtc()
{
  MIX_ENV=test mix coveralls.detail --filter $1
}

alias myip='curl ipinfo.io'
