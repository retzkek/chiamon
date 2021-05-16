#!/bin/bash

HOSTNAME=$(hostname)
docker-compose -f dcoker-compose.client.yml up -d
