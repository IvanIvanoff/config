export PATH="/Users/ivanivanov/.local/bin:$PATH"
DEFAULT_USER="ivanivanov"
ZSH_THEME="robbyrussell"
# to enable history-search-multi-work
# git clone git@github.com:zdharma-continuum/history-search-multi-word.git ~/.oh-my-zsh/plugins
plugins=(cp mix git macos history-search-multi-word)

alias vim=nvim

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"
export LANG="en_US.UTF-8"
export UPDATE_ZSH_DAYS=5
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/opt/homebrew/opt/postgresql@17/bin:$PATH
export PATH="/Users/ivanivanov/.asdf/installs/nodejs/24.10.0/bin:$PATH"
export CLICOLOR=1
export TERM=xterm-256color

# Config how autocomplete works in Warp
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select
zstyle ':completion:*' file-sort modification

# pnpm
export PNPM_HOME="/Users/ivanivanov/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(jump shell)"
autoload -Uz compinit && compinit -i

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

local ret_status=%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )
# PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
# RPROMPT="[%D{%f/%m/%y}|%*]"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

source $ZSH/oh-my-zsh.sh
source "/opt/homebrew/opt/asdf/libexec/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)

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
<<<<<<< HEAD
alias gcm='git checkout master'
alias gcmn='git checkout main'
||||||| parent of d816fc9 (Update gitconfig and zshrc)
alias gcm='git checkout master'
=======
alias gcmn='git checkout main'
>>>>>>> d816fc9 (Update gitconfig and zshrc)
alias gp='git pull'
alias gpp='git pull --prune'
alias gfa='git fetch -a'
alias exformat='git diff master --name-only | grep "ex$\|exs$" | xargs mix format'

# Elixir stuff
alias mtdb='MIX_ENV=test mix do ecto.drop, ecto.create, ecto.load'
alias iex='iex --erl "-kernel shell_history enabled~"'
alias im='iex --erl "-kernel shell_history enabled" -S mix'
alias lb_imps='export PORT=4000  && iex --cookie mycookie --sname sanbase  --erl "-kernel shell_history enabled" -S mix phx.server'
alias lb_imps2='iex --name sanbase@127.0.0.1 --cookie mycookie -S mix'
alias imps='export PORT=4000  && iex --cookie mycookie --sname sanbase  --erl "-kernel shell_history enabled" -S mix phx.server'
alias imps2='export PORT=4001 && iex --cookie mycookie --sname sanbase2 --erl "-kernel shell_history enabled" -S mix phx.server'
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

# Checkout master or main branch
function gcm() {
  # Check if in a git repo
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: This is not a git directory!"
        exit 1
    fi

  # Gather local branches
  branches=$(git branch --list | sed 's/^..//')
  have_master=$(echo "$branches" | grep -Fx 'master')
  have_main=$(echo "$branches" | grep -Fx 'main')
  
  echo "HEHEHEHEH"

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

alias ls='eza'
alias ll='eza -lh --git'
alias llt='eza -lhTL2 --git'
alias rfzf='rg --files | fzf'
alias rfzfc='rg --files | fzf | pbcopy'

# Hack to allow watching aliases. For example now 'watch ll' will work with the above ll alias
alias watch='watch '
alias kgpsw='watch "kubectl get pod | rg sanbase"'

export GPG_TTY=$(tty)

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


################# GIT SYNC FUNCTION

sync_work() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Error: Not in a git repository"
        return 1
    fi

    # Get current branch name
    current_branch=$(git branch --show-current)

    # Check if we're on main or master branch
    if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
        echo "❌ Error: Cannot sync work on main/master branch"
        echo "Please switch to a feature branch first:"
        echo "  git checkout -b feature/your-branch-name"
        return 1
    fi

    echo "🔄 Syncing work on branch: $current_branch"

    # Check if there are any changes to commit
    if git diff --quiet && git diff --cached --quiet; then
        echo "ℹ️  No changes to commit"
    else
        # Add all files and commit
        echo "📝 Adding and committing changes..."
        git add .
        git commit -m "synced ongoing work"

        if [ $? -ne 0 ]; then
            echo "❌ Failed to commit changes"
            return 1
        fi
    fi

    # Push the branch
    echo "⬆️  Pushing to origin..."
    git push -u origin "$current_branch"

    if [ $? -ne 0 ]; then
        echo "❌ Failed to push to origin"
        return 1
    fi

    # Check if GitHub CLI is installed
    if ! command -v gh &> /dev/null; then
        echo "⚠️  GitHub CLI not installed. Cannot create PR automatically."
        echo "Install with: brew install gh (macOS) or visit: https://cli.github.com/"
        echo "✅ Branch synced successfully!"
        return 0
    fi

    # Check if there's already a PR for this branch
    echo "🔍 Checking for existing PR..."
    existing_pr=$(gh pr list --head "$current_branch" --json number --jq '.[0].number' 2>/dev/null)

    if [ -n "$existing_pr" ] && [ "$existing_pr" != "null" ]; then
        echo "ℹ️  PR #$existing_pr already exists for this branch"
        echo "🔗 View PR: $(gh pr view $existing_pr --json url --jq '.url')"
    else
        # Create a new PR
        echo "🚀 Creating new PR..."

        # Get the default branch (main or master)
        default_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)

        # Create PR with a basic template
        pr_title="Work in progress: $current_branch"
        pr_body="## Summary
This PR contains ongoing work from the $current_branch branch.

**Status:** 🚧 Work in Progress

## Changes
- Synced ongoing development work
- Auto-created by sync_work function

---
*This PR was automatically created. Please update the title and description as needed.*"

        pr_url=$(gh pr create --title "$pr_title" --body "$pr_body" --base "$default_branch" --head "$current_branch" --draft 2>/dev/null)

        if [ $? -eq 0 ]; then
            echo "✅ Draft PR created: $pr_url"
        else
            echo "⚠️  Could not create PR automatically. You may need to:"
            echo "   - Authenticate with GitHub CLI: gh auth login"
            echo "   - Or create the PR manually on GitHub"
        fi
    fi

    echo "✅ Sync completed successfully!"
    echo "📊 Summary:"
    echo "   Branch: $current_branch"
    echo "   Status: Pushed to origin"
    if [ -n "$existing_pr" ] && [ "$existing_pr" != "null" ]; then
        echo "   PR: #$existing_pr (existing)"
    elif [ -n "$pr_url" ]; then
        echo "   PR: Created (draft)"
    fi
}
################# END GIT SYNC FUNCTION

# OpenClaw Completion
source "/Users/ivanivanov/.openclaw/completions/openclaw.zsh"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# direnv for per-directory environment activation
eval "$(direnv hook zsh)"

# Developer supply chain security toolkit
export PATH="/Users/ivanivanov/security/bin:$PATH"
