#! /bin/bash


WPA_CONF=${WPA_CONF-/etc/wpa_supplicant.conf}

# SSID PASSPHRASE
add () {
  wpa_passphrase "$1" "$2" >> $WPA_CONF
  exit 0
}

parse () {
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
  get_interface
  wpa_supplicant -i $INTERFACE -c $WPA_CONF
  exit $?
}

open () {
  #connect to an open wifi
  get_interface
  iw connect "$INTERFACE" -w "$1"
}

"$@"

echo 'USAGE scan|connect|add {network} {pass}|open {network}|dump|interface'
