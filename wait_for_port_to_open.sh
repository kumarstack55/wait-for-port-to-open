#!/bin/bash
script_name=$(basename "$0")
host_default='localhost'
service_default='service'

usage() {
  cat <<__USAGE__ >&2
Usage: $script_name [OPTIONS...] [-- COMMAND [ARGS...]]
Wait for the port opened on the host and execute the command.

Options:
-H host      Target host to check port. (default:$host_default)
-p port      Target port to check.
-s service   Service name for output. (default:$service_default)

Examples:
  Wait for web service on 192.168.1.1 to start.
    $ ${script_name} -H 192.168.1.1 -p 80

  Wait for selenium to start before running app.
    $ ${script_name} -p 4444 -s 'Selenium' -- python app.py
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

test_host_port_open() {
  nc -z "$1" "$2"
}

wait_for() {
  local host="$1" port="$2" service="$3"

  : "${host:=$host_default}"
  : "${service:=$service_default}"

  err "Waiting $service to launch on ${host}:${port}..."
  while ! test_host_port_open "$host" "$port"; do
    sleep 0.5
  done
  err "${service} launched."
}

main() {
  local host port service opt

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

  if [ ! "${port:+x}" ]; then
    die "No port was specified."
  fi

  wait_for "$host" "$port" "$service"

  if [ $# -gt 0 ]; then
    err "Executing command: '$*'."
    "$@"
  fi
}

main "$@"
