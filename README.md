# wifi.sh

bash script to connect to wifi

# Usage

``` bash
npm install -g wifi.sh

#list currently available wifi networks.
sudo wifi.sh scan

#connect to best network
sudo wifi.sh connect

#add a network to file.
sudo wifi.sh add SSID passphrase

#show current interface

wifi.sh interface

# this defaults to the LAST interface
# it finds, for me, this is the most recent USB wifi
# dongle I plugged in.

# set interface manually like this:

sudo INTERFACE=wlan0 wifi.sh connect

```

## License

MIT
