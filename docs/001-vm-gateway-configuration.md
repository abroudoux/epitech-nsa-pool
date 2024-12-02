# VM Gateway Configuration

## Gateway Setup

### Configure Network Interfaces

List networks interfaces : `ifconfig`

#### `em0` Network Interface

```bash
# /etc/hostname.em0
dhcp
```

#### Others Network Interfaces

Edit or create config files on `/etc/hostname.<interface>` to create a new network interface

```bash
# For the network 1 on em1
echo "inet 10.0.1.1 255.255.255.0" > /etc/hostname.em1
```

Restart interfaces to apply changes

```bash
sh /etc/netstat
```
