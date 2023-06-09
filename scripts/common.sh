#!/bin/bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# General
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Start the installation at this time of the day (HH, 0-23)
START_HOUR=12

# Name of the tmux session
TMUX_SESSION=dreijahreszeiten

# Path to base directory
BASE_DIR=$HOME/dreijahreszeiten

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Screen
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Wide screen
SCREEN_ROTATION=left
SCREEN_OUTPUT=HDMI2

# Mirrored screen
SCREEN_2_OUTPUT=HDMI2

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Network
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Bright Sign display
BRIGHT_SIGN_HOST=192.168.1.111
BRIGHT_SIGN_PORT=5000

# Arduino Nanos

# Stepper Motors: Berlin, Eisberg, Fenster, Hong Kong
ARDUINO_1_HOST=192.168.1.113
ARDUINO_1_PORT=8888

# Rotation & Servo Motors: Camera L, Camera R (Servo), Ship (Rotation)
ARDUINO_2_HOST=192.168.1.112
ARDUINO_2_PORT=8888

# LEDs
ARDUINO_3_HOST=192.168.1.114
ARDUINO_3_PORT=8888

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ePaper
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Clear the screen from ghosting artifacts every nth frame
EPAPER_GHOST=32

# Only take nth frame from 30fps video for epaper display to get to 5fps
EPAPER_TAKE=6

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Motors
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Maximum speed (used for resetting)
MAX_STEP_SPEED=4500

# Fenster Stepper
FENSTER_ID=fenster
FENSTER_SPEED=2000
FENSTER_MIN=0
FENSTER_MAX=65000

# Berlin Stepper
BERLIN_ID=berlin
BERLIN_SPEED=1400
BERLIN_MIN=0
BERLIN_MAX=53000

# Eisberg Stepper
EISBERG_ID=eisberg
EISBERG_SPEED=1000
EISBERG_MIN=0
EISBERG_MAX=-65000

# Hong Kong Stepper
HONGKONG_ID=hongkong
HONGKONG_SPEED=1200
HONGKONG_MIN=0
HONGKONG_MAX=42000

# Servo Kameras
KAMERA_STANDBY=90
KAMERA_L_ID=kamera_l
KAMERA_L_MIN=0
KAMERA_L_MAX=160
KAMERA_R_ID=kamera_r
KAMERA_R_MIN=30
KAMERA_R_MAX=170

# Schiff
SCHIFF_ENABLE=schiff_an
SCHIFF_DISABLE=schiff_aus

# Wind (Gebläse)
WIND_ENABLE=wind_an
WIND_DISABLE=wind_aus
