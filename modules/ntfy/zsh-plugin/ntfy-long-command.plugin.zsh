function ntfy_timer() {
  export _NTFY_LONG_CMD_START="$( date +%s )"
  export _NTFY_LONG_CMD="$1"
}

function ntfy_push_notification() {
  [[ "${_NTFY_LONG_LAST_START}" == "${_NTFY_LONG_CMD_START}" ]] && return
  export _NTFY_LONG_LAST_START="${_NTFY_LONG_CMD_START}"
  [[ "" == "${_NTFY_LONG_CMD_START}" || " " == "${_NTFY_LONG_CMD:0:1}" ]] && return
  local NTFY_ALLOWLIST=( "apt" )
  NTFY_ALLOWLIST+=("${(@s: :)NTFY_LONG_ALLOWLIST}")
  [[ ! "${NTFY_ALLOWLIST[(ie)${_NTFY_LONG_CMD/% *}]}" -le "${#NTFY_ALLOWLIST}" ]] && return
  local NTFY_CMD_END="$( date +%s )"
  (( TIME_TAKEN = NTFY_CMD_END - _NTFY_LONG_CMD_START ))
  [[ ${NTFY_LONG_SECONDS:-300} -gt "${TIME_TAKEN}" ]] && return
  ntfy publish "'${_NTFY_LONG_CMD}' finished after ${TIME_TAKEN} seconds"
}

preexec_functions=("${(@)preexec_functions:#ntfy_timer}")
preexec_functions+=(ntfy_timer)

precmd_functions=("${(@)precmd_functions:#ntfy_push_notification}")
precmd_functions+=(ntfy_push_notification)
