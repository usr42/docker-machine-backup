#!/bin/sh

usage() {
    echo "usage: $0 MACHINE_NAME"
    cleanup
    exit 1
}

check_machine_exists() {
    local NAME=$1

    if [ ! -d "$HOME/.docker/machine/machines/$NAME" ]; then
        echo "Docker machine \"$NAME\" does not exist. Use \"docker-machine ls\" to list machines."
        usage
    fi
}

cleanup() {
    rm -rf $TMP_DIR
}

BASEDIR="$(pwd)"
TMP_DIR=$(mktemp -d)
cd $TMP_DIR

if [ $# -lt 1 ]; then
    usage
fi

MACHINE_NAME=$1

check_machine_exists $MACHINE_NAME

DEST_DIR=$TMP_DIR/$MACHINE_NAME
MACHINE_DIR="$HOME/.docker/machine/machines/$MACHINE_NAME"
CERTS_DIR="$HOME/.docker/machine/certs"
OUTPUT_FILE=docker-machine-$MACHINE_NAME-backup.tar.gz

TEMPLATE_MACHINE_NAME="___MACHINE_NAME___"
TEMPLATE_HOME_DIR="___HOME_DIR___"

mkdir $DEST_DIR
cd $DEST_DIR
cp $MACHINE_DIR/*.pem $MACHINE_DIR/config.json $MACHINE_DIR/id_rsa* $DEST_DIR
cp $CERTS_DIR/*.pem $DEST_DIR

sed -i.bak "s|$HOME|${TEMPLATE_HOME_DIR}|g" $DEST_DIR/config.json
sed -i.bak "s|/$MACHINE_NAME/|/${TEMPLATE_MACHINE_NAME}/|g" $DEST_DIR/config.json
sed -i.bak -e "s|\(\"Name\" *: *\"\)$MACHINE_NAME\"|\1${TEMPLATE_MACHINE_NAME}\"|g" $DEST_DIR/config.json
sed -i.bak "s|.docker/machine/certs/|.docker/machine/machines/${TEMPLATE_MACHINE_NAME}/|g" $DEST_DIR/config.json

cd $DEST_DIR
tar czf $BASEDIR/$OUTPUT_FILE .
echo Backup file created: $OUTPUT_FILE

cleanup
