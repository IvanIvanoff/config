DEFAULT_USER="ivanivanov"
ZSH_THEME="robbyrussell"
plugins=(cp mix git macos)

alias vim=lvim

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="lvim"
export LANG="en_US.UTF-8"
export UPDATE_ZSH_DAYS=5
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

eval "$(jump shell)"
autoload -Uz compinit && compinit -i

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

local ret_status=%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
# RPROMPT="[%D{%f/%m/%y}|%*]"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

source $ZSH/oh-my-zsh.sh
source "/opt/homebrew/opt/asdf/libexec/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)

alias tmux='tmux -2' #start with 256 color
alias ..='cd ..'
alias ,,='cd -'
alias fhere="find . -name "
alias mkdir="mkdir -pv"
alias pc='pbcopy'
alias pp='pbpaste'

vimgitshow() { git show "$1" | vim - "+set filetype=${1##*.}"; }

# connect to clickhouse
CH_VERSION="22.1.3.7"
# (C)lick(H)ouse (S)tage|(P) (D)efault|(F)acing
alias chds='docker run -it --rm --network host yandex/clickhouse-client:${CH_VERSION} --port 30900 -h clickhouse.stage.san'
alias chfs='docker run -it --rm --network host yandex/clickhouse-client:${CH_VERSION} --port 31900 -h clickhouse.stage.san'
alias chdp='docker run -it --rm --network host yandex/clickhouse-client:${CH_VERSION} --port 30900 -h clickhouse.production.san'
alias chfp='docker run -it --rm --network host yandex/clickhouse-client:${CH_VERSION} --port 31900 -h clickhouse.production.san'
# Git aliases
alias g='git'
alias gs='git status'
alias gcm='git checkout master'
alias gp='git pull'
alias gpp='git pull --prune'
alias gfa='git fetch -a'
alias exformat='git diff master --name-only | grep "ex$\|exs$" | xargs mix format'

# Elixir stuff
alias mtdb='MIX_ENV=test mix do ecto.drop, ecto.create, ecto.load'
alias iex='iex --erl "-kernel shell_history enabled~"'
alias im='iex --erl "-kernel shell_history enabled" -S mix'
alias imps='iex --cookie mycookie --sname sanbase --erl "-kernel shell_history enabled" -S mix phx.server'
alias impsn='iex --cookie mycookie --erl "-kernel shell_history enabled" -S mix phx.server'
alias iex='iex --erl "-kernel shell_history enabled"'
alias mc='mix compile'
alias mt='mix test'
alias mta='MIX_ENV=test mix test_all --formatter Sanbase.FailedTestFormatter --formatter ExUnit.CLIFormatter'
alias mf='mix format'
alias mdg='mix deps.get'

alias myip='curl ipinfo.io'

# kubectl
alias kgp='kubectl get pods'
alias pkgp='prodkubectl get pods'
alias kgps='kubectl get pods | rg sanbase'
alias pkgps='prodkubectl get pods | rg sanbase'
alias kgpc="kubectl get pods | rg -e 'clickhouse-[012]'"
alias kgpi='kubectl get pods | rg influxdb'
alias klf='kubectl logs -f'
alias klft='kubectl logs -f --tail=100'
alias klp='kubectl logs -p'
alias prodkubectl='kubectl --kubeconfig /Users/${DEFAULT_USER}/.kube/prod-config'

klftn(){
 kubectl logs -f --tail=5000 $1 | gsed 's/\\n/\n/g'
}

pklftn() {  
  prodkubectl logs -f --tail=5000 $1 | gsed 's/\\n/\n/g' 
}

who_listens()
{
  lsof -nP -i4TCP:$1 | grep LISTEN
}

remote_console(){
  kubectl exec -it $1 /app/bin/sanbase remote
}

premote_console(){
  prodkubectl exec -it $1 /app/bin/sanbase remote
}

kubelogs() {
  kubectl logs -f $1 > $2
}

alias ls='exa'
alias ll='exa -lh --git'
alias llt='exa -lhTL2 --git'
alias rfzf='rg --files | fzf'
alias rfzfc='rg --files | fzf | pbcopy'

# Hack to allow watching aliases. For example now 'watch ll' will work with the above ll alias
alias watch='watch '
alias kgpsw='watch "kubectl get pod | rg sanbase"'

export GPG_TTY=$(tty)

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
