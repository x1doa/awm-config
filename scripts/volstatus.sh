#!/bin/bash

amixer -D default get Master toggle | tail -n 1 | awk '{print $6}' | tr -d '[]'
