#!/bin/bash
v4l2-ctl -d /dev/video2 --set-ctrl=focus_auto=0
v4l2-ctl -d /dev/video2 --set-ctrl=saturation=130
v4l2-ctl -d /dev/video2 --set-ctrl=brightness=130
v4l2-ctl -d /dev/video2 --set-ctrl=sharpness=150
v4l2-ctl -d /dev/video2 --set-ctrl=focus_absolute=0
v4l2-ctl -d /dev/video2 --set-ctrl=gain=20
v4l2-ctl -d /dev/video2 --set-ctrl=exposure_auto=1
v4l2-ctl -d /dev/video2 --set-ctrl=exposure_absolute=450
v4l2-ctl -d /dev/video2 --set-ctrl=zoom_absolute=110
v4l2-ctl -d /dev/video2 --set-ctrl=pan_absolute=10800
v4l2-ctl -d /dev/video2 --set-ctrl=tilt_absolute=-32400
v4l2-ctl -d /dev/video2 --set-ctrl=backlight_compensation=0
v4l2-ctl -d /dev/video2 --set-ctrl=white_balance_temperature_auto=0
v4l2-ctl -d /dev/video2 --set-ctrl=white_balance_temperature=4000
