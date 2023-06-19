# Snort Training Demo
This repo is designed to provide a quick training resource with snort

## Prerequisite
1. Docker
2. Docker-compose

## Install
Clone the code from the repo
```sh
git clone git@github.com:roostercoopllc/snort3-demo-fork.git
cd snort3-demo-fork
```

Copy the `.env-dev` to a local `.env` so that docker uses local Environmental resources without needing admin to system environment variables.
```sh
cp .env-dev .env
```

Build and start the snort 
```sh
docker-compose up -d # The Container is built through docker-compose which is a little nicer
```

Enter into the interactive shell
```sh
docker-compose exec snort /bin/bash
```

Training resources will be able to be dropped into folder that is specified in the `.env` (./demo-pcap-files by default) on your local machine, and will be available in `/opt/training-resources` to run command against.
```sh
ls /opt/training-resources
```

You can then use snort on any of the files in the attached volume
```sh
# if placed in the local directory that is mounted in the container
snort /opt/training-resources/<pcap-file placed in the local dir>
```

### Helpful Commands
```sh
# Quick restart 
docker-compose restart
# Quick destroy
docker-compose down
```
## References and Shout outs
1. [Snort Demo Example](https://github.com/snort3/snort3_demo)