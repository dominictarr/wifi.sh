#! /bin/bash


WPA_CONF=${WPA_CONF-/etc/wpa_supplicant.conf}

# SSID PASSPHRASE
add () {
  # wpa_passphrase dumps the error message on stdout
  # because they do not understand unix.
  PASS=`wpa_passphrase "$1" "$2"` || {
    echo $PASS 1>&2
    exit 1
  }
  echo >> $WPA_CONF
  exit 0
}

parse () {
  #there is a bug here for some wifi networks that have spaces in the name(?)
  # TODO: parse out the encryption.
  while read signal;
  do
    read SSID
    signal=${signal#*: }
    signal=${signal% *}
    SSID=${SSID#*: }
    #filter out empty SSID.
    if [ "$SSID" != "SSID:" ]; then
      printf '%-40s, %5s\n' "$SSID" "$signal"
    fi
  done
}

scan () {
  get_interface
  echo 'SSID                                    , SIGNAL'
  iw dev "$INTERFACE" scan \
  | grep -E 'SSID|signal' \
  | parse \
  | sort -k 3
  # to  be honest, I can't figure out the correct parameters
  # to sort, but this seems to produce good output.
  exit 0
}


parse_interface () {
  while read line;
  do
    iface=${line#*: }
    iface=${iface%%:*}
  done
  echo $iface
}

get_interface () {
  INTERFACE=${INTERFACE-$(ip -o link | parse_interface)}
}

interface () {
  get_interface
  echo $INTERFACE
  exit 0
}

dump () {
  cat $WPA_CONF
  exit 0
}

connect () {
  dhcpcd #start dhcpcd if necessary
  get_interface
  wpa_supplicant -i $INTERFACE -c $WPA_CONF
  exit $?
}

open () {
  # because iw does not block, we need to start it,
  # and then start polling the status.
  # if the connection drops, reconnect automatically.

  dhcpcd #start dhcpcd if necessary
  get_interface

  while true
  do
    iw dev "$INTERFACE" disconnect
    iw dev "$INTERFACE" connect -w "$1"
    STATUS=

    while [ "$STATUS" != 'Not connected.' ]
    do
      sleep 1
      STATUS=$(iw dev "$INTERFACE" link)
      echo "$STATUS"
    done
  done
  exit $?
}

disconnect () {
  get_interface
  killall wpa_supplicant
  iw dev "$INTERFACE" disconnect
  exit 0
}

version () {
  v=$(grep version package.json)
  v=${v%'"'*}
  v=${v##*'"'}
  echo $v
  exit 0
}

[ "$1" = "-v" ] && version

"$@"

echo 'USAGE scan|connect|add {network} {pass}|open {network}|dump|interface|version' >&2

