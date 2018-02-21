#!/bin/bash

export PORT=5101

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start

