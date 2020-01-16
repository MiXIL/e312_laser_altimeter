# Laser Altimeter Driver

This is a very simple driver that connects to the Lightware SF11/C laser altimeter via USB serial connection. The software is plug and play with USRP E312 SDRs.

## Setup

It is recommended to copy the binary program `sfc11_serial` to `/usr/local/bin/` on the USRP E312 so that it can be run
globally (assuming `/usr/local/bin/` has been added to the system PATH)

## Usage

Connect the SF11/C device to a USB port and run the command:
```
$ sfc11_serial
```
The program will stream timestamped data to the terminal and save data to a default file named `sfc11_output.log`

To specify a custom output file run:
```
$ sfc11_serial myfile.log
```

To specify a custom output file and suppress printing to terminal (quiet mode) run:
```
$ sfc11_serial myfile.log --quiet
```
or
```
$ sfc11_serial myfile.log -q
```

## Output Format

For convenience, the matlab function `read_sfc11_log.m` is provided to read outputs.

The program outputs laser altimeter data in the following format:

```
<UTC timestamp>  <alitude> <measured voltage> <measurement strength>
```

### Example Stream Outputs
```
GMT2020-01-16-02:59:10.538     5.40 m  0.442 V  100 %
GMT2020-01-16-02:59:10.579     5.40 m  0.443 V  100 %
GMT2020-01-16-02:59:10.629     5.41 m  0.443 V  100 %

```

## A note on timestamps

The E312 USRP has an integrated GPS receiver. A NTP daemon runs by default to align system time to GPS time. However, some improvements can be made to the default NTP configuration file `/etc/ntp.conf` on the USRP E312 to enable more reliable time alignment.

Simply copy the `config/ntp.conf` file included in the `config` folder to `/etc/ntp.conf` on the USRP E312.

## E312 Network configuration

### /etc/network/interfaces

We provide an example `/etc/network/interfaces` file which allows a static ethernet connection and WiFI connection with a connected USB-Wifi dongle. Note that for WiFI to work, `/etc/wpa_supplicant.conf` must be properly setup as well.

```
# /etc/network/interfaces -- configuration file for ifup(8), ifdown(8)

# The loopback interface
auto lo
iface lo inet loopback

# Wireless interfaces
auto wlan0
iface wlan0 inet dhcp
	wireless_mode managed
	wireless_essid any
	wpa-driver nl80211
	wpa-roam /etc/wpa_supplicant.conf
	wpa-conf /etc/wpa_supplicant.conf

iface atml0 inet dhcp

# Wired or wireless interfaces
# auto eth0
# iface eth0 inet dhcp
# iface eth1 inet dhcp
auto eth0
iface eth0 inet static
	address 192.168.10.2
        netmask 255.255.255.0
        gateway 192.168.10.254
# Ethernet/RNDIS gadget (g_ether)
# ... or on host side, usbnet and random hwaddr
iface usb0 inet static
	address 192.168.7.2
	netmask 255.255.255.0
	network 192.168.7.0
	gateway 192.168.7.1

# Bluetooth networking
iface bnep0 inet dhcp

```

### /etc/wpa_supplicant.conf

We also provide an example `/etc/wpa_supplicant.conf` file for connecting to a WiFI networks. Note that for a given network, the key_mgmt may differ and can be found in the router configuration. A higher priority means that the network will be connected to first if multiple networks are available.

```
#ctrl_interface=/var/run/wpa_supplicant
#ctrl_interface_group=0
update_config=1

network={
    ssid="An open WiFI network"
    key_mgmt=NONE
    id_str="opennetwork"
    priority=1
}

network={
    ssid="Name of low priority WIFI Network"
    psk="password"
    key_mgmt=WPA-PSK
    id_str="mylowprioritynetwork"
    priority=1
}

network={
    ssid="Name of a prefferred network"
    psk="password"
    key_mgmt=WPA-PSK
    id_str="myprefferrednetwork"
    priority=2
}

```
