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
* [it8951-video](https://github.com/adzialocha/it8951-video)
* `figlet`
* `bash`
* `tmux`

### Clone repository in home folder

```bash
git clone https://github.com/adzialocha/dreijahreszeiten
```

### Link all dotfiles

```bash
ln -s ./dreijahreszeiten/.bashrc .
# etc.
```

### Enable auto login

1. Edit `/etc/systemd/logind.conf`
2. Change `NAutoVTs` to `6` and `ReserveVT` to `7`, uncomment both of them
3. Create the following folder and edit the `override.conf` file:
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
