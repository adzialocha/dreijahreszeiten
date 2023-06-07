# dreijahreszeiten

Linux setup and control scripts to run "Die drei Jahreszeiten" theater installation with all connected peripherals: 3x Audio Speakers, Waveshare 7.8inch e-Paper HAT via IT8951 controller, 3x Waveshare 11.9inch LCD via HDMI, 3x Arduino Nano controlling motors via Ethernet, 90x90cm LCD display with BrightSign controller via Ethernet.

## Setup

* Tested on ASRock DeskMini 310 with Intel Core i7 8700T CPU, Samsung 970 Evo Plus 500GB and 16GB G.Skill Ripjaws memory
* Operating System: Ubuntu Server 22.04.2

### Install dependencies

* `ffmpeg`
* X11 with `xinit` and `xterm`
* `mplayer`
* `aplay`
* `figlet`
* `tmux`
* [it8951-video](https://github.com/adzialocha/it8951-video)
* [rkpzavav](https://github.com/adzialocha/romans-kleines-programm-zum-abspielen-von-avi-videos)

### Clone repository in home folder

```bash
git clone https://github.com/adzialocha/dreijahreszeiten
```

### Link all dotfiles

```bash
ln -s ./dreijahreszeiten/.bashrc .
# etc.
```

### Setup static IP address

Edit `/etc/netplan/00-installer-config.yaml`

```yaml
network:
  version: 2
  ethernets:
    eno1:
      optional: true
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.1.100/24
      nameservers:
        addresses: 
          - 192.168.1.1
          - 8.8.8.8
      routes:
        - to: default
          via: 192.168.1.1
```

### Enable auto login

1. Edit `/etc/systemd/logind.conf`
2. Change values to `NAutoVTs=6` and `ReserveVT=7`, uncomment both of them
3. Create the following folder and edit `override.conf` file:
    ```bash
    sudo mkdir /etc/systemd/system/getty@tty1.service.d/
    sudo vim /etc/systemd/system/getty@tty1.service.d/override.conf
    ```
    Contents of `override.conf`:
    ```
    [Service]
    ExecStart=
    ExecStart=-/sbin/agetty --noissue --autologin <your user name> %I $TERM
    Type=idle
    ```

### Disable audio powersave mode to prevent clicking noise

```bash
echo "options snd_hda_intel power_save=0" | sudo tee -a /etc/modprobe.d/audio_disable_powersave.conf
```
