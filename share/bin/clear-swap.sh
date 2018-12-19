#!/bin/sh
set -eu

# require root permission

swapoff -a && swapon -a
