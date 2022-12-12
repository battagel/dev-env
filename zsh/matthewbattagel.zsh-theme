# ZSH Theme - Preview: https://cl.ly/f701d00760f8059e06dc
# Thanks to gallifrey, upon whose theme this is based

local return_code="%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})"

function my_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  GIT_STATUS=$(git_prompt_status)
  [[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

ACCENT_COL="$(tput setaf 215)"
TEXT_COL1="$(tput setaf 249)"
RESET_COL="$(tput sgr0)"

PROMPT='%{${TEXT_COL1}%}%n%{$reset_color%}@%{${ACCENT_COL}%}%m%{$reset_color%}:%{${TEXT_COL1}%} %2~%{$reset_color%} $(my_git_prompt_info)%{$reset_color%}%B»%b '

# This method caused issue where newline would be created at a weird length
#PROMPT='${TEXT_COL1}%n${RESET_COL}@${ACCENT_COL}%m${RESET_COL}:${TEXT_COL1}%2~ $(my_git_prompt_info)${RESET_COL}%B»%b '

#PROMPT='%{$fg[blue]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%} %{$fg[blue]%}%2~%{$reset_color%} $(my_git_prompt_info)%{$reset_color%}%B»%b '

RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"
