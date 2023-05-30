# wait-for-port-to-open

A tiny wrapper script that performs port checks to control the startup order, etc.

## Requirements

* Netcat (`nc`)

## Usage

```bash
# Get the wrapper script in the current directory.
curl -o wait_for_port_to_open.sh https://raw.githubusercontent.com/kumarstack55/wait-for-port-to-open/main/wait_for_port_to_open.sh

# Install netcat if necessary.
sudo apt-get install netcat

# Output help with options, examples, etc.
./wait_for_port_to_open.sh -h

# After PostgreSQL starts, execute the command.
./wait_for_port_to_open.sh -s 'PostgreSQL' 192.168.1.1:5432 -- python ./app.py
# or
./wait_for_port_to_open.sh -s 'PostgreSQL' -H 192.168.1.1 -p 5432 -- python ./app.py
```

```console
$ ./wait_for_port_to_open.sh -h
Usage1: wait_for_port_to_open.sh [OPTIONS...] [-- COMMAND [ARGS...]]
Usage2: wait_for_port_to_open.sh [OPTIONS...] host:port [-- COMMAND [ARGS...]]
Wait for the port opened on the host and execute the command.

Options:
-H host      Target host to check port. (default:localhost)
-p port      Target port to check. If you specify a port as an option,
             you cannot use the "host:port" format.
-s service   Service name for output. (default:service)

Examples:
  Wait for web service on localhost to start.
    $ wait_for_port_to_open.sh -p 80
    $ wait_for_port_to_open.sh :80

  Wait for selenium:4444 to start before running app.
    $ wait_for_port_to_open.sh -s Selenium -H selenium -p 4444 -- python app.py
    $ wait_for_port_to_open.sh -s Selenium selenium:4444 -- python app.py
```

## LICENSE

MIT
