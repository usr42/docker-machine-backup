#!/bin/sh

usage() {
    echo "usage: $0 MACHINE_NAME BACKUP_FILE"
    exit 1
}

check_machine_exists() {
    local NAME=$1

    if [ -d "$HOME/.docker/machine/machines/$NAME" ]; then
        echo "Docker machine with name \"$NAME\" does already exist. Use a different name."
        usage
    fi
}


if [ $# -lt 2 ]; then
    usage
fi

MACHINE_NAME=$1
BACKUP_FILE=$(pwd)/$2

check_machine_exists $MACHINE_NAME
if [ ! -f "$BACKUP_FILE" ]; then
    echo "BACKUP_FILE \"$BACKUP_FILE\" does not exist."
    usage
fi

MACHINE_DIR="$HOME/.docker/machine/machines/$MACHINE_NAME"
TEMPLATE_MACHINE_NAME="___MACHINE_NAME___"
TEMPLATE_HOME_DIR="___HOME_DIR___"

mkdir $MACHINE_DIR
tar xzf $BACKUP_FILE -C $MACHINE_DIR

sed -i.bak1 "s|${TEMPLATE_HOME_DIR}|$HOME|g" $MACHINE_DIR/config.json
sed -i.bak2 "s|\([/\"]\)$TEMPLATE_MACHINE_NAME\([/\"]\)|\1$MACHINE_NAME\2|g" $MACHINE_DIR/config.json

echo "Successfully restored $2 as docker machine with name $MACHINE_NAME"

