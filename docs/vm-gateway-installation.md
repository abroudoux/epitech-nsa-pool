# VM Gateway Installation

## Global Setup

See `setup-openbsd` commands [file](/cmd/setup-openbsd.sh)

## Gateway Setup

### Configure Network Interfaces

List networks interfaces : `ifconfig`

Attribute IP address to a network interface : edit or create config files on `etc/hostname.<interface>`

```bash
# For the network 1 on em1
echo "inet 10.0.1.1 255.255.255.0" > etc/hostname.em1
```

Restart interfaces to apply changes

```bash
sh /etc/netstat
```

Configure the network interface connected to Internet (e.g `em0`) with public address or `DHCP`

```bash
echo "inet 192.168.1.10 255.255.255.0" > /etc/hostname.em0
# OR
echo "dhcp" > /etc/hostname.em0
```

### Enable IP Forwarding
