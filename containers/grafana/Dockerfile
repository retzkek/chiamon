FROM grafana/grafana:latest-ubuntu
ARG prometheus_ip=prometheus
ARG loki_ip=loki
ENV ENV_PROMETHEUS_IP=${prometheus_ip}
ENV ENV_LOKI_IP=${loki_ip}

USER root
RUN apt update && apt install gettext -y && rm -rf /var/lib/apt/lists/*

COPY dashboards /etc/grafana/dashboards/
COPY dashboards.yaml /etc/grafana/provisioning/dashboards/
COPY datasources.yaml /etc/grafana/provisioning/datasources/datasources.yaml.template 
RUN envsubst < /etc/grafana/provisioning/datasources/datasources.yaml.template > /etc/grafana/provisioning/datasources/datasources.yaml
