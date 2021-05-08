# ChiaMon

Example using [mtail](https://github.com/google/mtail) to collect metrics from
[Chia](https://chia.net) logs,
[chia_exporter](https://github.com/retzkek/chia_exporter) to collect metrics
from the Chia node, with a [docker-compose](https://github.com/docker/compose/)
stack to collect data with [Prometheus](https://prometheus.io/) and graph in
[Grafana](https://grafana.com).

![Chia dashboard](https://img.kmr.me/posts/chiamon2.png)

## mtail program

The mtail program is in `mtail/chialog.mtail`. Currently it only collects harvester metrics:

* `chia_harvester_blocks_total`: cumulative number of block challenges attempted
* `chia_harvester_plots_total`: current number of plots
* `chia_harvester_plots_eligible`: cumulative number of plots that passed filter
* `chia_harvester_proofs_total`: cumulative number of proofs won
* `chia_harvester_search_time`: histogram of proof search times

## chia_exporter

The [chia_exporter](https://github.com/retzkek/chia_exporter) is used to collect
metrics from the Chia node [RPC
API](https://github.com/Chia-Network/chia-blockchain/wiki/RPC-Interfaces).

## Grafana dashboard

The Grafana dashboard is in `grafana/dashboards/Chia.json`. It defines a number
of variables that will be auto-populated from the node metrics; use the
dropdowns to customize to show show the drives, mounts, etc that you're
interested in monitoring.

## Stack

**This stack was created for development on Linux. See notes below for other platforms.**

The docker-compose file will mount the Chia log from
`$HOME/.chia/mainnet/log/debug.log`, verify that this location is correct and
set the log level to INFO in the Chia configuration (usually at
`$HOME/.chia/mainnet/config/config.yaml`).

Run:

    docker-compose up -d
    
This will do the following:

* Build container image with configuration for mtail from source
* Build container image for chia_exporter from source
* Download node_exporter, prometheus, and grafana images from docker hub
* Run containers in the background, attached to the host network
    
The grafana service provisions the prometheus datasource and a basic dashboard
that displays harvester and node metrics.

Access Grafana at http://localhost:3000 and login with the default admin/admin
username and password (you'll be prompted to change the password).

### Notes

* This is not a production-ready deployment; there's no persistence of Prometheus
data or the Grafana database, so changes will be lost when the services are
recreated. To do that you'd want to bind-mount local paths to the respective
data directories; consult each project's documentation for details.

* It's highly encouraged to run the node exporter natively rather than in
  docker - see the discussion in the [node_exporter
  docs](https://github.com/prometheus/node_exporter#docker). If you do run it in
  Docker, you'll need to bind-mount in any other volumes you want to monitor
  (add them to the `volumes` list in `docker-compose.yml`, e.g. `-
  '/scratch:/scratch'`). See [issue #3](https://github.com/retzkek/chiamon/issues/3).

* To run this on **Windows**, you'll need to use the [Windows
exporter](https://github.com/prometheus-community/windows_exporter) instead of
the node_exporter, and change the dashboard appropriately. See [issue
#2](https://github.com/retzkek/chiamon/issues/2) and the [windows branch](https://github.com/retzkek/chiamon/tree/windows) for details and a modified configuration and dashboard.

* On **Mac** you'll need to run node_exporter natively, not under Docker: `brew
  install node_exporter`. Remove the `node_exporter` service from the docker-compose config.
