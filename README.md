# wait-for-port-to-open

A tiny wrapper script that performs port checks to control the startup order, etc.

## Requirements

* Netcat (`nc`)

## Usage

```bash
# Install netcat if necessary.
sudo apt-get install netcat

# Get the wrapper script in the current directory.
curl -o wait_for_port_to_open.sh https://raw.githubusercontent.com/kumarstack55/wait-for-port-to-open/main/wait_for_port_to_open.sh

# Output help with options, examples, etc.
./wait_for_port_to_open.sh -h

# After PostgreSQL starts, execute the command.
./wait_for_port_to_open.sh -H 192.168.1.1 -p 5432 -s 'PostgreSQL' -- python ./app.py
```

## LICENSE

MIT
