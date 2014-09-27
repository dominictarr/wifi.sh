#! /bin/bash

WPA_CONF=${WPA_CONF-/etc/wpa_supplicant.conf}

isroot () {
  # check that the script is running as root
  # this is required for controlling wifi device.

  if [ $UID -ne 0 ]; then
    echo 'Error: must run as root to access wifi devices' >&2
    exit 1
  fi
}

add () {
  # wpa_passphrase dumps the error message on stdout
  # because they do not understand unix.

  PASS=`wpa_passphrase "$1" "$2"` || {
    echo Error: $PASS 1>&2
    exit 1
  }
  echo >> $WPA_CONF
  exit 0
}

parse () {

  while read LINE;
  do
    LINE=${LINE# *}

    case "$LINE" in
      BSS*)
        if [ x"$BSS" != x ]; then
          printf '%-40s, %5s , %s\n' "$SSID" "$SIGNAL" "$ENC"
          SIGNAL=
          ENC=
        fi
        BSS=${LINE#BSS }
        BSS=${BSS%(*}
      ;;
      SSID*)
        SSID=${LINE#SSID: }
        if [ "$SSID" = "SSID:" ]; then
          SSID=$BSS
        fi
      ;;
      signal*)
        SIGNAL=${LINE#signal: }
        SIGNAL=${SIGNAL% dBm}
      ;;
      *)
        E=${LINE%%:*}
        E="$E"${LINE#*Version: }
        ENC="$ENC$E "
      ;;
    esac
  done
  printf '%-40s, %5s , %s\n' "$SSID" "$SIGNAL" "$ENC"
}

_scanraw () {
  iw dev "$INTERFACE" scan \
  | grep -E '(^BSS)|SSID|signal|WPA|WPS|WEP|RSN'
}

scanraw () {
  isroot
  get_interface
  _scanraw
  exit 0
}

scan () {
  isroot
  get_interface
  echo 'SSID                                    , SIGNAL , SECURITY'

  # to be honest, I can't figure out the correct parameters
  # to sort, but this seems to produce good output.
  _scanraw | parse | sort -k 3
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
  isroot
  dhcpcd #start dhcpcd if necessary
  get_interface
  wpa_supplicant -i $INTERFACE -c $WPA_CONF
  exit $?
}

open () {
  # because iw does not block, we need to start it,
  # and then start polling the status.
  # if the connection drops, reconnect automatically.

  isroot
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
  v=$(grep version $(dirname $(realpath "$0"))/package.json)
  v=${v%'"'*}
  v=${v##*'"'}
  echo $v
  exit 0
}

[ "$1" = "-v" ] && version

"$@"

echo 'USAGE scan|connect|add {network} {pass}|open {network}|dump|interface|version' >&2

