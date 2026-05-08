#!/bin/bash

# TODO autodetect version number of codex without npm
docker build -t codex:0.129.0 -t codex:latest .
