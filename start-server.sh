#!/bin/bash

export HOSTNAME=$(hostname)
docker-compose -f docker-compose.server.yml build
docker-compose -f docker-compose.server.yml up -d
