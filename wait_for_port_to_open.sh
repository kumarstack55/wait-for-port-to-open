#!/bin/bash
set -u

script_name=$(basename "$0")
host_default='localhost'
service_default='service'

usage() {
  cat <<__USAGE__ >&2
Usage1: ${script_name} [OPTIONS...] [-- COMMAND [ARGS...]]
Usage2: ${script_name} [OPTIONS...] host:port [-- COMMAND [ARGS...]]
Wait for the port opened on the host and execute the command.

Options:
-H host      Target host to check port. (default:${host_default})
-p port      Target port to check. If you specify a port as an option,
             you cannot use the "host:port" format.
-s service   Service name for output. (default:${service_default})

Examples:
  Wait for web service on localhost to start.
    $ ${script_name} -p 80
    $ ${script_name} :80

  Wait for selenium:4444 to start before running app.
    $ ${script_name} -s Selenium -H selenium -p 4444 -- python app.py
    $ ${script_name} -s Selenium selenium:4444 -- python app.py
__USAGE__
  exit 1
}

err() {
  echo "${script_name}: $1" >&2
}

die() {
  err "$1"
  exit 1
}

check_that_command_exists() {
  local command="$1"
  type "$command" >/dev/null 2>&1 \
    || die "To run ${script_name}, you need to install ${command}."
}

scan_port() {
  nc -z "$1" "$2"
}

wait_for() {
  local port="$1" host="$2" service="$3"

  : "${host:=$host_default}"
  : "${service:=$service_default}"

  err "Waiting $service to launch on ${host}:${port}..."
  while ! scan_port "$host" "$port"; do
    sleep 0.5
  done
  err "Service ${service} has opened port."
}

wait_for_and_execute() {
  local port="$1" host="$2" service="$3"
  shift 3

  check_that_command_exists nc
  wait_for "$port" "$host" "$service"

  if [ $# -gt 0 ]; then
    err "Executing command: '$*'."
    "$@"
  fi
}

main() {
  local host="" port="" service="" opt
  local host_port

  while getopts "H:hp:s:" opt; do
    case $opt in
      H) host="$OPTARG";;
      h) usage;;
      p) port="$OPTARG";;
      s) service="$OPTARG";;
      \?) usage;;
    esac
  done
  shift $((OPTIND-1))

  if [[ ! "${port:+x}" ]]; then
    if [[ "$#" -gt 0 ]]; then
      host_port="$1"
      shift

      [[ $host_port =~ ^([^:]*):([0-9]+)$ ]] \
        || die "Invalid host:port format. (host_port: ${host_port})"

      host="${BASH_REMATCH[1]}"
      port="${BASH_REMATCH[2]}"
    else
      die "No port was specified."
    fi
  fi

  if [[ $# -gt 0 && $1 == "--" ]]; then
    shift
  fi

  wait_for_and_execute "$port" "$host" "$service" "$@"
}

main "$@"
