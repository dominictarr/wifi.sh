# wifi.sh

bash script to connect to wifi (on linux)

# Usage

``` bash
npm install -g wifi.sh

#list currently available wifi networks.
sudo wifi.sh scan

#connect to best network
sudo wifi.sh connect

#add a network to file.
sudo wifi.sh add SSID passphrase

# show your mac address

sudo wifi.sh mac

# set your mac address randomly.

sudo wifi.sh randmac

# set your mac address manually

sudo wifi.sh 01:23:45:67:89:ab

#show current interface

wifi.sh interface

# this defaults to the LAST interface
# it finds, for me, this is the most recent USB wifi
# dongle I plugged in.

# set interface manually like this:

sudo INTERFACE=wlan0 wifi.sh connect

# set wpa_supplicant.conf location

sudo WPA_CONF=/etc/wpa_supplicant.conf wifi.sh connect

# connect to open network

sudo wifi.sh open "A great SSID"

# disconnect any wifi network

sudo INTERFACE=wlan0 wifi.sh disconnect
```


```

## Cool Links

Some other wifi utils on npm,

* [wit](https://github.com/substack/wit)
* [wireless](https://github.com/tlhunter/node-wireless)
* [wifi-password (for osx)](https://github.com/rauchg/wifi-password)

These both use node, wifi.sh has the distinction that it is
all in bash, so will run where there are very low resources,
such as on a raspberry pi.

## License

MIT
