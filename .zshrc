# Startup profiling: `ZPROF=1 zsh -i -c exit` prints where startup time goes.
[[ -n $ZPROF ]] && zmodload zsh/zprof

export PATH="$HOME/.local/bin:$PATH"
ZSH_THEME=""   # prompt lives in ~/config/zsh/prompt.zsh (sourced below)
# to enable history-search-multi-work
# git clone git@github.com:zdharma-continuum/history-search-multi-word.git ~/.oh-my-zsh/plugins
plugins=(cp mix git macos history-search-multi-word)

alias vim=nvim

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export LANG="en_US.UTF-8"
zstyle ':omz:update' frequency 5
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/opt/homebrew/opt/postgresql@17/bin:$PATH
export CLICOLOR=1

# Erlang asdf/kerl install opts
export KERL_BUILD_DOCS=yes
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=/opt/homebrew/opt/openssl@3"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Run a `tool init`-style command once and cache its output, instead of
# starting the tool at every shell start. The cache is rebuilt when the tool
# moves (brew upgrade changes its Cellar path), its binary gets newer, the
# arguments change, or a file passed with -d changes.
# Force a rebuild: rm ~/.cache/zsh/init-*.zsh
_cached_init() {
  local -a deps
  while [[ $1 == -d ]]; do deps+=("$2"); shift 2; done
  local bin=${commands[$1]}
  [[ -n $bin ]] || return 0                      # tool not installed: skip
  local cache="$HOME/.cache/zsh/init-$1.zsh" stamp="# ${bin:A} $*" head= f stale=0
  [[ -r $cache ]] && read -r head < "$cache"
  [[ $head == "$stamp" && ! $bin -nt $cache ]] || stale=1
  for f in $deps; do [[ $f -nt $cache ]] && stale=1; done
  if (( stale )); then
    mkdir -p "${cache:h}"
    { print -r -- "$stamp"; command "$@" } >| "$cache" 2>/dev/null || { rm -f "$cache"; return 1 }
  fi
  source "$cache"
}

_cached_init jump shell

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh
source "/opt/homebrew/opt/asdf/libexec/asdf.sh"

# Completion tweaks. Must come after oh-my-zsh, which sets its own completion
# styles (including a case- and hyphen-insensitive matcher-list).
zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu no                   # fzf-tab replaces the menu
zstyle ':completion:*' file-sort modification

# fzf-tab: Tab opens completions in an fzf list (type to filter, Enter picks,
# < > switch groups). Load after compinit (oh-my-zsh) and before fzf,
# autosuggestions and syntax highlighting, which wrap Tab and other widgets.
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh

# History: keep a lot, and record when each command started and how long it ran.
# `hist` shows the last 30 with date, time and duration; `hist 100` shows more.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=250000                 # in memory; must exceed SAVEHIST so HIST_EXPIRE_DUPS_FIRST has room
SAVEHIST=200000                 # on disk
setopt EXTENDED_HISTORY         # save ": <start>:<duration>;<command>"
unsetopt SHARE_HISTORY INC_APPEND_HISTORY   # both write entries before they finish (duration 0)
setopt INC_APPEND_HISTORY_TIME  # write each entry right after it finishes, with its real duration
setopt HIST_IGNORE_SPACE        # a command starting with a space is not saved
setopt HIST_REDUCE_BLANKS
hist() { fc -liD -"${1:-30}"; }

source "$HOME/config/zsh/prompt.zsh"

# fzf: Ctrl-T picks a file, Alt-C jumps to a directory, `vim **<Tab>` completes
# paths. Lists come from fd (skips .gitignored files); previews use bat / eza.
# Loaded before atuin, so atuin keeps Ctrl-R.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir()  { fd --type d --hidden --exclude .git . "$1"; }
_cached_init fzf --zsh

# zsh-autosuggestions: shows the rest of a matching past command in faint text
# as you type (atuin's history first, then zsh's). → or End accepts it all,
# Alt-F accepts one word. Must load before atuin, which plugs itself in.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# atuin: searchable history with cwd, duration and exit code (Ctrl-R).
# Config lives in this repo. Up-arrow keeps zsh's normal behavior.
export ATUIN_CONFIG_DIR="$HOME/config/atuin"
_cached_init -d "$ATUIN_CONFIG_DIR/config.toml" atuin init zsh --disable-up-arrow

# No autosuggestions for commands that take a pod name: pods get new names on
# every deploy, so names remembered in history are usually dead. Press Tab
# instead, which lists live pods (see "Pod-name completion" below).
_kpod_cmds='(ksh|pksh|klftn|pklftn|remote_console|premote_console)'
ZSH_AUTOSUGGEST_HISTORY_IGNORE="${_kpod_cmds} *"
if (( $+functions[_zsh_autosuggest_strategy_atuin] )); then
  functions[_zsh_autosuggest_strategy_atuin_all]=$functions[_zsh_autosuggest_strategy_atuin]
  _zsh_autosuggest_strategy_atuin() {
    [[ $1 == ${~_kpod_cmds}' '* ]] && return
    _zsh_autosuggest_strategy_atuin_all "$@"
  }
fi

# Shift+Enter sends a code zsh doesn't know (it types ";2;13~"); treat it as Enter.
bindkey '^[[27;2;13~' accept-line

alias claude_no_sandbox='claude --settings "{\"sandbox\":{\"enabled\":false}}"'

alias wsc='wt switch --create --execute=claude'

alias tmux='tmux -2' #start with 256 color
alias ..='cd ..'
alias ,,='cd -'
alias fhere="find . -name "
alias mkdir="mkdir -pv"
alias pc='pbcopy'
alias pp='pbpaste'

vimgitshow() { git show "$1" | vim - "+set filetype=${1##*.}"; }

# connect to clickhouse
CH_VERSION="21.3.20.1"
CH_DOCKERHUB_ACCOUNT="clickhouse/clickhouse-client"
# (C)lick(H)ouse (S)tage|(P) (D)efault|(F)acing

alias ch_new='docker run -it --rm --network host --entrypoint clickhouse clickhouse/clickhouse-server:24.3 client --network host --port 30900 -h clickhouse.stage.san'

alias chds='docker run -it --rm --network host ${CH_DOCKERHUB_ACCOUNT}:${CH_VERSION} --port 30900 -h clickhouse.stage.san'
alias chfs='docker run -it --rm --network host ${CH_DOCKERHUB_ACCOUNT}:${CH_VERSION} --port 31900 -h clickhouse.stage.san'
alias chdp='docker run -it --rm --network host ${CH_DOCKERHUB_ACCOUNT}:${CH_VERSION} --port 30900 -h clickhouse.production.san'
alias chfp='docker run -it --rm --network host ${CH_DOCKERHUB_ACCOUNT}:${CH_VERSION} --port 31900 -h clickhouse.production.san'
# Git aliases
alias g='git'
alias gs='git status'
alias gcmn='git checkout main'
alias gp='git pull'
alias gpp='git pull --prune'
alias gfa='git fetch -a'
alias exformat="git diff master --name-only --diff-filter=d | grep '\.exs\?$' | xargs mix format"

# Elixir stuff
alias mtdb='MIX_ENV=test mix do ecto.drop, ecto.create, ecto.load'
# Enable IEx shell history for every iex/erl session
export ERL_AFLAGS="-kernel shell_history enabled"
alias im='iex -S mix'
alias lb_imps='PORT=4000 iex --cookie mycookie --sname sanbase -S mix phx.server'
alias lb_imps2='iex --name sanbase@127.0.0.1 --cookie mycookie -S mix'
alias imps='PORT=4000 iex --cookie mycookie --sname sanbase -S mix phx.server'
alias imps2='PORT=4001 iex --cookie mycookie --sname sanbase2 -S mix phx.server'
alias impsn='iex --cookie mycookie -S mix phx.server'
alias mc='mix compile'
alias mt='mix test'
alias mta='MIX_ENV=test mix test_all --formatter Sanbase.FailedTestFormatter --formatter ExUnit.CLIFormatter'
alias mf='mix format'
alias mdg='mix deps.get'

alias myip='curl ipinfo.io'

# kubectl
alias prodkubectl='kubectl --kubeconfig $HOME/.kube/prod-config'
alias kgp='kubectl get pods'
alias pkgp='prodkubectl get pods'
# k9s: full-screen Kubernetes UI. Prod always opens read-only.
# Config lives in this repo; per-cluster state there is gitignored.
export K9S_CONFIG_DIR="$HOME/config/k9s"
alias pk9s='k9s --kubeconfig $HOME/.kube/prod-config --readonly'
# -A lists every namespace (first column = namespace); filter keeps sanbase pods
# (default ns) + everything in the llm-agent / llm-sandbox namespaces.
alias kgps="kubectl get pods -A | rg 'sanbase|^llm-|github-exporter'"
alias pkgps="prodkubectl get pods -A | rg 'sanbase|^llm-|github-exporter'"
alias kgpc="kubectl get pods | rg -e 'clickhouse-[012]'"
alias klf='kubectl logs -f'
alias klft='kubectl logs -f --tail=100'
alias klp='kubectl logs -p'
alias videv='vim .env.dev'

# viddy runs commands with sh, which doesn't know zsh aliases. This expands the first
# alias it finds (and aliases inside it, like prodkubectl) and passes viddy the whole
# command as one string, so a pipe inside the alias runs inside viddy:
#   viddy kgps      viddy -n 5 pkgps
viddy() {
  local -i i=1
  local cmd w seen=' '
  local -a words
  # Skip viddy's own options (and the values of those that take one) to find the command.
  while (( i <= $# )) && [[ ${@[i]} == -* ]]; do
    [[ ${@[i]} == (-n|--interval|--shell|--save|--load) ]] && (( i++ ))
    (( i++ ))
  done
  (( i <= $# )) && (( $+aliases[${@[i]}] )) || { command viddy "$@"; return }
  cmd=${(j: :)@[i,-1]}
  while words=(${(z)cmd}); w=$words[1]; (( $+aliases[$w] )) && [[ $seen != *" $w "* ]]; do
    seen+="$w "
    cmd="${aliases[$w]}${cmd#"$w"}"
  done
  command viddy "${@[1,i-1]}" "$cmd"
}
alias v='viddy'

# y: yazi file manager. Quit with q and the shell moves to the folder you were in;
# Q quits without moving.
y() {
  local tmp cwd
  tmp=$(mktemp -t yazi-cwd.XXXXXX) || return
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n $cwd && $cwd != $PWD ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Checkout master or main branch
function gcm() {
  # Check if in a git repo
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: This is not a git directory!"
        return 1
    fi

  # Gather local branches
  branches=$(git branch --list | sed 's/^..//')
  have_master=$(echo "$branches" | grep -Fx 'master')
  have_main=$(echo "$branches" | grep -Fx 'main')

  if [ -n "$have_master" ] && [ -n "$have_main" ]; then
    echo "🚫 Both 'master' and 'main' branches exist. Ambiguous operation."
    return 2
  elif [ -n "$have_main" ]; then
    echo "🔀 Checking out 'main' branch..."
    git checkout main
  elif [ -n "$have_master" ]; then
    echo "🔀 Checking out 'master' branch..."
    git checkout master
  else
    echo "❓ Neither 'main' nor 'master' branch found."
    return 3
  fi
}
gddm() {
    git difftool -d "${1:-master}..$(git branch --show-current)"
}

# Logs by pod name from ANY namespace: resolve the pod's namespace first
# (kubectl takes exactly one -n; there is no multi-namespace logs), fall back
# to default if the pod is not found anywhere.
klftn(){
  local ns=$(kubectl get pods -A --no-headers 2>/dev/null | awk -v p="$1" '$2==p{print $1; exit}')
  kubectl logs -f --tail=5000 -n "${ns:-default}" "$1" | gsed 's/\\n/\n/g'
}

pklftn() {
  local ns=$(prodkubectl get pods -A --no-headers 2>/dev/null | awk -v p="$1" '$2==p{print $1; exit}')
  prodkubectl logs -f --tail=5000 -n "${ns:-default}" "$1" | gsed 's/\\n/\n/g'
}

# Follow logs of every pod whose name matches a regex, in all namespaces, with
# a pod/container prefix per line. New pods (e.g. after a deploy) are picked up.
# Extra stern flags pass through:  ks sanbase-web -i error --since 5m --tail 200
ks()  { stern -A --tail 50 "$@"; }
pks() { stern --kubeconfig "$HOME/.kube/prod-config" -A --tail 50 "$@"; }

# Pod-name completion for the pod helpers: Tab and `**<Tab>` list the pods
# running right now (all namespaces). Prod helpers ask the prod cluster.
_kpod_names()  { kubectl get pods -A --no-headers -o custom-columns=:metadata.name 2>/dev/null; }
_pkpod_names() { kubectl --kubeconfig "$HOME/.kube/prod-config" get pods -A --no-headers -o custom-columns=:metadata.name 2>/dev/null; }
_kpods()  { local -a pods; pods=(${(f)"$(_kpod_names)"});  compadd -a pods; }
_pkpods() { local -a pods; pods=(${(f)"$(_pkpod_names)"}); compadd -a pods; }
compdef _kpods  ksh klftn remote_console
compdef _pkpods pksh pklftn premote_console
_fzf_complete_ksh()             { _fzf_complete -- "$@" < <(_kpod_names); }
_fzf_complete_klftn()           { _fzf_complete -- "$@" < <(_kpod_names); }
_fzf_complete_remote_console()  { _fzf_complete -- "$@" < <(_kpod_names); }
_fzf_complete_pksh()            { _fzf_complete -- "$@" < <(_pkpod_names); }
_fzf_complete_pklftn()          { _fzf_complete -- "$@" < <(_pkpod_names); }
_fzf_complete_premote_console() { _fzf_complete -- "$@" < <(_pkpod_names); }

# Shell into a pod by name from ANY namespace (same namespace-resolution trick
# as klftn). Prefers bash, falls back to sh for slim images without bash.
ksh() {
  local ns=$(kubectl get pods -A --no-headers 2>/dev/null | awk -v p="$1" '$2==p{print $1; exit}')
  kubectl exec -it -n "${ns:-default}" "$1" -- sh -c 'command -v bash >/dev/null && exec bash || exec sh'
}

pksh() {
  local ns=$(prodkubectl get pods -A --no-headers 2>/dev/null | awk -v p="$1" '$2==p{print $1; exit}')
  prodkubectl exec -it -n "${ns:-default}" "$1" -- sh -c 'command -v bash >/dev/null && exec bash || exec sh'
}

who_listens()
{
  lsof -nP -i4TCP:"$1" | grep LISTEN
}

remote_console(){
  kubectl exec -it "$1" -- /app/bin/sanbase remote
}

premote_console(){
  prodkubectl exec -it "$1" -- /app/bin/sanbase remote
}

kubelogs() {
  kubectl logs -f "$1" > "$2"
}

alias ls='eza'
alias ll='eza -lh --git'
alias llt='eza -lhTL2 --git'
alias rfzf='rg --files | fzf'
alias rfzfc='rg --files | fzf | pbcopy'

# Hack to allow watching aliases. For example now 'watch ll' will work with the above ll alias
alias watch='watch '
alias kgpsw='watch "kubectl get pod | rg sanbase"'

export GPG_TTY=$TTY

# sync_work: commit everything, push, open a draft PR
source "$HOME/config/zsh/sync_work.zsh"

_cached_init -d "$HOME/.config/worktrunk/config.toml" wt config shell init zsh

# direnv for per-directory environment activation
_cached_init direnv hook zsh

# Developer supply chain security toolkit
export PATH="$HOME/security/bin:$PATH"
export CURL_CA_BUNDLE="$HOME/.config/certs/cert.pem"

# Must stay last: it wraps every ZLE widget defined before it.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -n $ZPROF ]] && zprof
