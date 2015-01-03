#! /bin/bash

# make sure we are in the right place.
cd $(dirname $(realpath "$0"))

# source wifi script
. ../index.sh

# parse

set -e

diff <(cat fixtures/gregs-laptop.ip-o_link | grep 'state UP' | parse_interface) \
  <(echo wlp3s0)
#diff fixtures/gregs-laptop.ip-o_link <(cat fixtures/IstanbulAirport.wifi | preparse | parse)

echo PASSED


