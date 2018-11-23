# docker-machine-backup
Backup and restore docker machine configurations

## Usage
### Backup a docker machine configuration
```
./backup-docker-machine.sh MACHINE_NAME
```

Example:
```
./backup-docker-machine.sh vbox-machine
```

### Restore a docker machine configuration backup
```
./restore-docker-machine.sh MACHINE_NAME BACKUP_FILE
```
Example:
```
./restore-docker-machine.sh imported-vbox docker-machine-vbox-backup.tar.gz
```

