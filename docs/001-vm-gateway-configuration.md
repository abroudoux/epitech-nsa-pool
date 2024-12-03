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
set block-policy drop  # Bloque tout trafic non autorisé (droppé silencieusement)
set loginterface $ext_if # Log les paquets sur l'interface externe

# NAT (masquerade) : Permet aux LANs d'accéder à Internet
match out on $ext_if from {$lan1_net, $lan2_net, $lan3_net} to any nat-to ($ext_if)

# Politique par défaut
block all              # Bloque tout par défaut

# Autoriser le trafic redirigé
pass in on $ext_if proto tcp to 127.0.0.1 port 22 keep state

# Réponses aux connexions NAT (entrant)
pass in on $ext_if inet proto tcp from any to ($ext_if) keep state
pass in on $ext_if inet proto udp from any to ($ext_if) keep state

# LAN-1 (Administration) : accès complet
pass in on $lan1_if from $lan1_net to any keep state

# LAN-2 (Serveur) : autorise uniquement le trafic nécessaire
pass in on $lan2_if from $lan2_net to $lan1_net keep state

# LAN-3 (Employés) : accès HTTP/HTTPS uniquement au serveur dans LAN-2
pass in on $lan3_if proto { tcp udp } from $lan3_net to $lan2_net port { http https } keep state

# Trafic sortant vers Internet pour tous les LANs
pass out on $ext_if to any keep state
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
