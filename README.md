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

## LICENSE

MIT
