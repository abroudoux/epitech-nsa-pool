# Change keybindings to fr
kbd fr

# Install nano
pkg_add nano

# Restart sshd
/etc/rc.d/sshd restart

# Create doas conf
nano /etc/doas.conf
permit nopass user
doas su

# Edit em0 interfaces
echo dhcp > /etc/hostname.em0

# Configure interface
echo "inet <network> <mask>" > /etc/hostname.em1

# Check if IP forwarding is enabled

echo net.inet.ip.forwarding=1 > /etc/sysctl.conf
sysctl net.inet.ip.forwarding # Should return 1

# Configure LANs
nano /etc/pf.conf

# LANs
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

# Start DHCP
rcctl start dhcpd

# Check if DHCP is running
rcctl check dhcpd

# Edit paquet filter
nano /etc/pf.conf

# Rules


# Reload PF conf
pfctl -f /etc/pf.conf

# Check PF rules
pfctl -sr

# Check Internet
ping 8.8.8.8 80
curl -I http://google.com