# ChiaMon

Example using [mtail](https://github.com/google/mtail) to collect metrics from
[Chia](https://chia.net) logs, with
[docker-compose](https://github.com/docker/compose/) stack to collect data with
[Prometheus](https://prometheus.io/) and graph in
[Grafana](https://grafana.com).

## mtail program

The mtail program is in `mtail/chialog.mtail`. Currently it only collects harvester metrics:

* `chia_harvester_blocks_total`: cumulative number of block challenges attempted
* `chia_harvester_plots_total`: current number of plots
* `chia_harvester_plots_eligible`: cumulative number of plots that passed filter
* `chia_harvester_proofs_total`: cumulative number of proofs won
* `chia_harvester_search_time`: histogram of proof search times

## Grafana dashboard

The Grafana dashboard is in `grafana/dashboards/Chia.json`. It assumed the
Prometheus datasource is named `Prometheus`, that the plotting drive is mounted
at `/chia_tmp` and that the farming drives are mounted at `/farm*` (if your
setup is different, change the dashboard, not your setup!).

## Stack

The docker-compose file will mount the Chia log from
`$HOME/.chia/mainnet/log/debug.log`, verify that this location is correct and
set the log level to INFO in the Chia configuration (usually at
`$HOME/.chia/mainnet/config/config.yaml`):

``` yaml
    log_level: INFO
```

Run:

    docker-compose up -d
    
This will do the following:

* Build container image with configuration for mtail from source
* Download node_exporter, prometheus, and grafana images from docker hub
* Run containers in the background
    
The grafana service provisions the prometheus datasource and a basic dashboard
that displays harvester and node metrics.

Access Grafana at http://localhost:3000 and login with the default admin/admin
username and password (you'll be prompted to change the password).

## Note

This is not a production-ready deployment; there's no persistence of Prometheus
data or the Grafana database, so changes will be lost when the services are
recreated. To do that you'd want to bind-mount local paths to the respective
data directories; consult each project's documentation for details.
