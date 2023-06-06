#!/bin/bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# General
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Name of the tmux session
TMUX_SESSION=dreijahreszeiten

# Path to base directory
BASE_DIR=$HOME/dreijahreszeiten

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

# LEDS
ARDUINO_3_HOST=192.168.1.114
ARDUINO_3_PORT=8888

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ePaper
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Only take nth frame from video for epaper display to get to 5fps
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
FENSTER_MIN_COMMAND=$FENSTER_ID,$FENSTER_MIN,$FENSTER_SPEED
FENSTER_MAX_COMMAND=$FENSTER_ID,$FENSTER_MAX,$FENSTER_SPEED

# Berlin Stepper
BERLIN_ID=berlin
BERLIN_SPEED=1400
BERLIN_MIN=0
BERLIN_MAX=53000
BERLIN_MIN_COMMAND=$BERLIN_ID,$BERLIN_MIN,$BERLIN_SPEED
BERLIN_MAX_COMMAND=$BERLIN_ID,$BERLIN_MAX,$BERLIN_SPEED

# Eisberg Stepper
EISBERG_ID=eisberg
EISBERG_SPEED=1000
EISBERG_MIN=0
EISBERG_MAX=-65000
EISBERG_MIN_COMMAND=$EISBERG_ID,$EISBERG_MIN,$EISBERG_SPEED
EISBERG_MAX_COMMAND=$EISBERG_ID,$EISBERG_MAX,$EISBERG_SPEED

# Hong Kong Stepper
HONGKONG_ID=hongkong
HONGKONG_SPEED=1200
HONGKONG_MIN=0
HONGKONG_MAX=42000
HONGKONG_MIN_COMMAND=$HONGKONG_ID,$HONGKONG_MIN,$HONGKONG_SPEED
HONGKONG_MAX_COMMAND=$HONGKONG_ID,$HONGKONG_MAX,$HONGKONG_SPEED

# Servo Kameras
KAMERA_L_MIN=0
KAMERA_L_MAX=160
KAMERA_R_MIN=30
KAMERA_R_MAX=170
KAMERA_STANDBY=90
