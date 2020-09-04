#!/bin/bash

echo $(uptime | sed 's/ min//' | awk '{print $3}' | sed 's/:/h /' | sed 's/,/min/')
