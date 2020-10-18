#!/bin/bash
sudo modprobe v4l2loopback exclusive_caps=1 video_nr=10 card_label="OBS Stream"

