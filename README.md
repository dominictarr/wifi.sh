# wifi.sh

bash script to connect to wifi

# Usage

``` bash
npm install -g wifi.sh
```

or

``` bash
bpkg install wifi
```

or

``` bash
bpkg install dominictar/wifi.sh
```

``` bash
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

# set wpa_supplicant.conf location

sudo WPA_CONF=/etc/wpa_supplicant.conf wifi.sh connect

```

## Cool Links

Some other `wpa_supplicant` wrappers on npm,

* [wit](https://github.com/substack/wit)
* [wireless](https://github.com/tlhunter/node-wireless)

These both use node, wifi.sh has the distinction that it is
all in bash, so will run where there are very low resources,
such as on a raspberry pi.

## License

MIT
