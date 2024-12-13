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

Launch DHCP server

```bash
nano /etc/rc.conf.local
dhcpd_flags=""
rcctl start dhcpd
rcctl check dhcpd
```

#### Configure Paquet Filter

Edit `/etc/pf.conf`

```bash
# Interfaces
ext_if = "em0"    # Interface Internet (externe)
lan1_if = "em1"   # Interface pour LAN-1 (Administration)
lan2_if = "em2"   # Interface pour LAN-2 (Serveur)
lan3_if = "em3"   # Interface pour LAN-3 (Employés)

# Réseaux
lan1_net = "192.168.42.0/26"
lan2_net = "192.168.42.64/26"
lan3_net = "192.168.42.128/26"

# Options globales
set skip on lo         # Ignore le filtrage sur l'interface loopback
set block-policy drop  # Bloque tout trafic non autorisé (droppé silencieuseme  nt)
set loginterface $ext_if # Log les paquets sur l'interface externe

# NAT (masquerade) : Permet aux LANs d'accéder à Internet
match out on $ext_if from {$lan1_net, $lan2_net, $lan3_net} to any nat-to ($ext_if)

block all

# Autoriser le trafic redirigé
pass in on $ext_if proto tcp to 127.0.0.1 port 22 keep state

################

# LAN1 -> Router
pass in on $lan1_if from $lan1_net to any keep state

# LAN1 -> LAN2 { http, https }
pass out on $lan2_if proto tcp from $lan1_net to $lan2_net port {80, 443} keep state

# LAN1 -> LAN2 { ssh }
pass out on $lan2_if proto tcp from $lan1_net to $lan2_net port 22 keep state
# LAN1 -> LAN3 { ssh }
pass out on $lan3_if proto tcp from $lan1_net to $lan3_net port 22 keep state

################

# LAN2 -> Router
pass in on $lan2_if from $lan2_net to any keep state

# LAN2 -x> LAN3
block in on $lan2_if from $lan2_net to $lan3_if

# LAN2 -x> LAN1
block in on $lan2_if from $lan2_net to $lan1_if

# LAN2 -> LAN1 { http, https }
pass out on $lan1_if proto tcp from $lan1_net to $lan2_net port {80, 443} keep state

# LAN2 -> LAN3 { http, https }
pass out on $lan3_if proto tcp from $lan2_net to $lan3_net port {80, 443} keep state

################

# LAN3 -> Router
pass in on $lan3_if from $lan3_net to any keep state

# LAN3 -x> LAN1
block in on $lan3_if from $lan3_net to $lan1_if

# LAN3 -x> LAN2
block in on $lan3_if from $lan3_net to $lan2_if

# LAN3 -> LAN2 { http, https }
pass out on $lan2_if proto tcp from $lan3_net to $lan2_net port {80, 443} keep state
################

# Router -> Internet
pass out on $ext_if from any to any keep state
```

#### Authorize forwardind port 22 to connect with ssh

```bash
pass in on $ext_if proto tcp to 127.0.0.1 port 22 keept safe # after block all
```

#### Reload PF conf

```bash
pfctl -f /etc/pf.conf
```

#### List PF conf

```bash
pfctl -sr
```

#### Test connexion

```bash
nc -vz 8.8.8.8 80
```

```bash
curl -I http://google.com
```

```bash
ping 8.8.8.8
```

#### Change Webserver adress to `192.168.24.70`

```bash
# /etc/dhcp.conf
host webserver {
    hardware ethernet <mac-address-of-the-webserver>;
    fixed address 192.168.24.70;
}
```
