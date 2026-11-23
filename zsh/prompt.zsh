# Calm prompt. Extra info only shows up when it matters.
#
#   ~/work/sanbase2 (main*)  /Users/me/work/sanbase2     <- short path, git branch (* = uncommitted
#                                                           changes), faint full path (only under ~)
#   ❯ mix test                                 14:32:07  <- time the prompt appeared
#   ...output...
#   ✗ exit 1 · 2m14s                                     <- only if the command failed or took >= 3s
#   ────────────────────────────────────────────────────  <- faint rule, only after a command ran
#
# Nothing is redrawn when you press Enter: what you see is what stays in scrollback.
#
# Sourced from ~/.zshrc after oh-my-zsh (uses its git_prompt_info).
#
# NOTE: PROMPT must contain the literal text $(git_prompt_info). Newer
# oh-my-zsh computes git info in the background and only does so when it
# finds that text in PROMPT; otherwise git_prompt_info always returns "".

zmodload zsh/datetime            # $EPOCHREALTIME
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST

: ${PROMPT_MIN_DURATION:=3}      # seconds before a duration is shown
ZLE_RPROMPT_INDENT=0             # no gap after the right prompt

# No colors here: the branch color is set around $(git_prompt_info) in PROMPT.
ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

typeset -g _prompt_start= _p_host= _p_full=

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

    # Faint full-width rule between the previous command's output and the new prompt.
    # Mid-gray (243) + faint lands close to the background in light and dark themes.
    print -r -- $'\e[2;38;5;243m'"${(l:COLUMNS::─:)}"$'\e[22;39m'
  fi

  _p_host=
  [[ -n $SSH_CONNECTION ]] && _p_host='%F{244}%n@%m%f '

  # Full path, faint, after the short one. Only under ~: elsewhere they'd be identical.
  _p_full=
  [[ $PWD == $HOME || $PWD == $HOME/* ]] &&
    _p_full="  "$'%{\e[2m%}%F{243}'"${PWD//\%/%%}"$'%f%{\e[22m%}'
}

add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_precmd

# Cyan short path, red branch, faint full path; then the arrow on its own line
# (red if the last command failed).
PROMPT='${_p_host}%F{cyan}%~%f%F{red}$(git_prompt_info)%f${_p_full}'$'\n''%(?.%F{green}.%F{red})❯%f '
RPROMPT='%F{240}%*%f'
