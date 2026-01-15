# EDITOR
export EDITOR="vi";
export VISUAL="vi";

# Credentials Management
export KDBX_PATH="/home/codestallion/syncthing/passwords/Passwords.kdbx"

function kp-open() {
  keepassxc-cli open $KDBX_PATH
}

function kp-create() {
  if [ -n "$3" ]; then
    keepassxc-cli add $KDBX_PATH -p $1 -u $2
  else
    keepassxc-cli add $KDBX_PATH -g $1 -u $2
  fi
}

function kp-list() {
  keepassxc-cli ls $KDBX_PATH
}

function kp-username() {
  keepassxc-cli show $KDBX_PATH $@ | grep UserName | cut --delimiter=":" --fields=2 | xargs
}

function kp-password() {
  keepassxc-cli show -s $KDBX_PATH $@ | grep Password | cut --delimiter=":" --fields=2 | xargs
}

function kp-code() {
  keepassxc-cli show -t $KDBX_PATH $@
}

function kp-delete() {
  keepassxc-cli rm $KDBX_PATH $@
}

## Cheatsheet
function cheat(){ curl https://cheat.sh/"$@"; }

# ID Generators
function vin() {
  echo "$(curl -sS https://randomvin.com/getvin.php\?type\=fake | tr -d '[:space:]')"
}

function uuid() {
    uuidgen | tr '[:upper:]' '[:lower:]'
}

# Docker
function clear-docker() {
  docker system prune -a -f --volumes
}

# Carbonyl Terminal Browser
function carbonyl() {
  docker run --rm -ti fathyb/carbonyl $@;
}

# PG Admin
function pgadmin() {
  docker run \
    -e PGADMIN_DEFAULT_EMAIL='henry@getpoint.io' \
    -e PGADMIN_DEFAULT_PASSWORD='password' \
    -p 4041:80 \
    --rm \
    'dpage/pgadmin4:7'
}

function clear-jdtls() {
  sudo rm -rf **/.settings;
  sudo rm -rf **/.project;
  sudo rm -rf ~/.cache;
  sudo rm -rf ~/.gradle;
  sudo rm -rf .gradle;
}

# Lombok For JDTLS
if [ -s "/Users/$(whoami)/.lombok/lombok.jar" ]
then
  export JDTLS_JVM_ARGS="-javaagent:/Users/$(whoami)/.lombok/lombok.jar";
fi
