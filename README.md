# ChiaMon

Example Chia monitoring stack, using:

* [mtail](https://github.com/google/mtail) to collect metrics from
  [Chia](https://chia.net) logs
* [chia_exporter](https://github.com/retzkek/chia_exporter) to collect metrics
  from the Chia node
* [node_exporter](https://github.com/prometheus/node_exporter) or [windows
  exporter](https://github.com/prometheus-community/windows_exporter/) to
  collect system metrics
* [prometheus](https://prometheus.io/) to store metrics
* [promtail](https://grafana.com/docs/loki/latest/clients/promtail/) and
  [loki](https://grafana.com/docs/loki/latest/) to collect and store logs from
  the Chia node and plotters (and system too if desired)
* [grafana](https://grafana.com) to display everything

This includes a [docker-compose](https://github.com/docker/compose/)
configuration to run everything, but this is primarily intended for development
and testing.

**WARNING this is NOT a one-click install, expect to need to do some work
setting everything up for your machine. PLEASE read the notes below and
understand what all the services are, what they do, and how they work
together.**

![Chia dashboard](https://img.kmr.me/posts/chiamon3.png)

## mtail program

The mtail program is in `mtail/chialog.mtail`. Currently it only collects harvester metrics:

* `chia_harvester_blocks_total`: cumulative number of block challenges attempted
* `chia_harvester_plots_total`: current number of plots
* `chia_harvester_plots_eligible`: cumulative number of plots that passed filter
* `chia_harvester_proofs_total`: cumulative number of proofs won
* `chia_harvester_search_time`: histogram of proof search times

**NOTE** you need to set log_level to INFO in your Chia config.yaml to get harvester metrics.

## chia_exporter

The [chia_exporter](https://github.com/retzkek/chia_exporter) is used to collect
metrics from the Chia node [RPC
API](https://github.com/Chia-Network/chia-blockchain/wiki/RPC-Interfaces).

## Grafana dashboard

The example Grafana dashboard is in `grafana/dashboards/Chia.json`. It defines a
number of variables that will be auto-populated from the node metrics. Grafana
dashboards are [easily customized](https://grafana.com/docs/) to show what
you're interested in seeing, in the way you find best; this dashboard is just
meant to demonstrate what can be done.

## Running on Linux/Mac

The docker-compose file will mount the Chia log from
`$HOME/.chia/mainnet/log/debug.log`, verify that this location is correct and
set the log level to INFO in the Chia configuration (usually at
`$HOME/.chia/mainnet/config/config.yaml`).

Run:

    docker-compose up -d

This will do the following:

* Build container image with configuration for mtail from source
* Build container image for chia_exporter from source
* Download other images from docker hub
* Run containers in the background, attached to the host network (this makes it
  easy to communicate with native services, but has some trade-offs. See notes.)

The grafana service provisions the prometheus and loki datasources and a basic
dashboard that displays harvester and node metrics.

Access Grafana at http://localhost:3000 and login with the default admin/admin
username and password (you'll be prompted to change the password).

### Notes

* It's highly encouraged to run the node exporter natively rather than in
  docker - see the discussion in the [node_exporter
  docs](https://github.com/prometheus/node_exporter#docker). If you do run it in
  Docker, you'll need to bind-mount in any other volumes you want to monitor
  (add them to the `volumes` list in `docker-compose.yml`, e.g. `-
  '/scratch:/scratch'`). See [issue #3](https://github.com/retzkek/chiamon/issues/3).

* On **Mac** you'll need to run node_exporter natively, not under Docker: `brew
  install node_exporter`. You'll probably need to change the networking setup
  too, since Docker on Mac runs in a VM. See the windows docker-compose and
  prometheus configs.

## Running on Windows

The node exporter **does not** work on Windows; instead you need to use the
Windows exporter for system metrics. Modified config and example dashboard are
in the [windows branch](https://github.com/retzkek/chiamon/tree/windows). You
may also want to review the discussion in [issue
#2](https://github.com/retzkek/chiamon/issues/2).

These steps will get you to a working setup (but aren't the only way):

* Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
* Install [Visual Studio Code](https://code.visualstudio.com/)
* Install [git](https://git-scm.com/)
* Install [Windows exporter](https://github.com/prometheus-community/windows_exporter/releases/download/v0.16.0/windows_exporter-0.16.0-386.msi)
* Clone the chiamon repository with VSCode
* Modify `docker-compose.yml`:
    - Change volume paths to point to your home directory.
* Run services. In VSCode with docker extension you can just right-click on `docker-compose.yml` and select "Compose Up"
* Check target status in Prometheus at http://localhost:9090/targets
* Access Grafana at http://localhost:3000 (admin/admin).

## Copyright & License

Copyright 2021 Kevin Retzke

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
details.

See LICENSE.txt
