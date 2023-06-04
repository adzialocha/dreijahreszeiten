# dreijahreszeiten

## Setup on Ubuntu Server

### Install dependencies

* `ffmpeg`
* `XOrg` with `xinit` and `xterm`
* `mplayer`
* `alsa-utils`
* https://github.com/adzialocha/it8951-video
* https://github.com/adzialocha/romans-kleines-programm-zum-abspielen-von-avi-videos

### Clone repository in home folder

### Link all dotfiles

```
ln -s ./dreijahreszeiten/.bashrc .
# etc.
```

### Enable auto login

1. Edit `/etc/systemd/logind.conf`
2. Change `NAutoVTs` to `6` and `ReserveVT` to `7`, uncomment both of them
3. Create the following folder and edit the `override.conf` file:
	```
	sudo mkdir /etc/systemd/system/getty@tty1.service.d/
	sudo vim /etc/systemd/system/getty@tty1.service.d/override.conf
	```

	Contents of `override.conf`:

	```
	[Service]
	ExecStart=
	ExecStart=-/sbin/agetty --noissue --autologin op %I $TERM
	Type=idle
	```
