#!/bin/bash

# Simple script to de-duplicate any added IPs, helpful for
# just dumping them in at the end of the file.

awk '/^#/ || !a[$0]++ || NF' servers.txt > servers.2.txt
