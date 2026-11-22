# Calm prompt. Extra info only shows up when it matters.
#
#   ~/work/sanbase2 main*                                <- cwd + git branch (* = uncommitted changes)
#   ❯ mix test
#
# After Enter, the prompt collapses to one dim line that keeps the context
# and the time the command started:
#
#   ~/work/sanbase2 main* ❯ mix test           14:32:07
#   ...output...
#   ✗ exit 1 · 2m14s                                     <- only if the command failed or took >= 3s
#
# Sourced from ~/.zshrc after oh-my-zsh (uses its git_prompt_info).
#
# NOTE: PROMPT must contain the literal text $(git_prompt_info). Newer
# oh-my-zsh computes git info in the background and only does so when it
# finds that text in PROMPT; otherwise git_prompt_info always returns "".

zmodload zsh/datetime            # $EPOCHREALTIME
autoload -Uz add-zsh-hook add-zle-hook-widget
setopt PROMPT_SUBST

: ${PROMPT_MIN_DURATION:=3}      # seconds before a duration is shown
ZLE_RPROMPT_INDENT=0             # no gap after the right prompt

# No colors here: the branch color is set around $(git_prompt_info) in PROMPT.
ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

typeset -g _prompt_start= _p_host= _p_dim= _p_end=

# 4.2s / 2m14s / 1h03m
_prompt_duration() {
  local -F secs=$1
  local -i s=$secs
  if (( s < 60 )); then
    printf '%.1fs' $secs
  elif (( s < 3600 )); then
    printf '%dm%02ds' $(( s / 60 )) $(( s % 60 ))
  else
    printf '%dh%02dm' $(( s / 3600 )) $(( s % 3600 / 60 ))
  fi
}

_prompt_preexec() {
  _prompt_start=$EPOCHREALTIME
}

_prompt_precmd() {
  local -i st=$?   # must stay first: exit status of the command that just ran

  # Summary line for the command that just finished (nothing after an empty Enter).
  if [[ -n $_prompt_start ]]; then
    local -F elapsed=$(( EPOCHREALTIME - _prompt_start ))
    local out=
    (( st != 0 )) && out="%F{red}✗ exit $st%f"
    if (( elapsed >= PROMPT_MIN_DURATION )); then
      [[ -n $out ]] && out+=" %F{240}·%f "
      out+="%F{244}$(_prompt_duration $elapsed)%f"
    fi
    [[ -n $out ]] && print -rP -- "$out"
    _prompt_start=
  fi

  # Full prompt: cyan dir, red branch, arrow on its own line (red if the last command failed).
  _p_host=
  [[ -n $SSH_CONNECTION ]] && _p_host='%F{244}%n@%m%f '
  _p_dim=
  _p_end=$'\n''%(?.%F{green}.%F{red})❯%f '
}

# After Enter, redraw the prompt as one line (dir, branch, arrow) in the same
# colors but faint (SGR 2), so it follows the terminal theme. Faint ends right
# after the arrow, so the command itself keeps its normal colors.
# The right side re-renders at the same moment, so it shows when the command started.
_prompt_transient() {
  [[ $CONTEXT == start ]] || return 0
  _p_dim=$'%{\e[2m%}'
  _p_end=' %(?.%F{green}.%F{red})❯%f'$'%{\e[22m%}'' '
  zle .reset-prompt
}

add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_precmd
zle -N _prompt_transient
add-zle-hook-widget zle-line-finish _prompt_transient

PROMPT='${_p_dim}${_p_host}%F{cyan}%~%f%F{red}$(git_prompt_info)%f${_p_end}'
RPROMPT='%F{240}%*%f'
