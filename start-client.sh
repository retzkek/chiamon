#!/bin/bash

HOSTNAME=$(hostname)
docker-compose -f docker-compose.client.yml build
docker-compose -f docker-compose.client.yml up -d