# VM Gateway Configuration

## Gateway Setup

### Configure Network Interfaces

List networks interfaces : `ifconfig`

#### `em0` Network Interface

```bash
# /etc/hostname.em0
dhcp
```

#### Create others Network Interfaces

Edit or create config files on `/etc/hostname.<interface>` to create a new network interface

```bash
# For the network 1 on em1
echo "inet <network> <mask>" > /etc/hostname.em1
```

Restart interfaces to apply changes

```bash
/etc/netstat
```

> Don't forget to activate LAN's in VirtualBox settings

Edit `etc/systctl.com`

```bash
net.inet.ip.forwarding=1
sysctl net.inet.ip.forwarding # Should return 1
```

### Configure DCHP server `/etc/dhcp.conf`

```bash
# lan-1
subnet 192.168.42.0 netmask 255.255.255.192 {
    range 192.168.42.40 192.168.42.60;
    option routers 192.168.42.1;
    option domain-name-servers 8.8.8.8, 8.8.4.4;
}

# lan-2
subnet 192.168.42.64 netmask 255.255.255.192 {
    range 192.168.42.70 192.168.42.110;
    option routers 192.168.42.65;
    option domain-name-servers 8.8.8.8, 8.8.4.4;
}

# lan-3
subnet 192.168.42.128 netmask 255.255.255.192 {
    range 192.168.42.140 192.168.42.180;
    option routers 192.168.42.129;
    option domain-name-servers 8.8.8.8, 8.8.4.4;
}
```
