#! /bin/bash

# make sure we are in the right place.
cd $(dirname $(realpath "$0"))

# source wifi script
. ../index.sh

# parse

set -e

diff fixtures/IstanbulAirport.scan <(cat fixtures/IstanbulAirport.wifi | preparse | parse)

echo PASSED

