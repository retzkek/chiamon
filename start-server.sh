#!/bin/bash

HOSTNAME=$(hostname)
docker-compose -f dcoker-compose.server.yml up -d
