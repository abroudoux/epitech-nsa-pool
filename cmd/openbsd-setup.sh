# Change keybindings to fr
kbd fr

# Install nano
pkg_add nano

# Restart sshd
/etc/rc.d/sshd restart

# Create doas conf
nano /etc/doas.conf
permit nopass user