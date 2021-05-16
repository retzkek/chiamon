FROM bitnami/prometheus
ARG node_exporter_ip=node_exporter
ARG chia_exporter_ip=chia_exporter
ARG mtail_harvester_ip=mtail
ENV ENV_NODE_IP=${node_exporter_ip}
ENV ENV_CHIA_EXPORTER_IP=${chia_exporter_ip}
ENV ENV_MTAIL_HARVESTER_IP=${mtail_harvester_ip}

USER root
RUN apt update && apt install gettext -y && rm -rf /var/lib/apt/lists/*
COPY prometheus.yml /etc/prometheus/prometheus.yml.template
RUN envsubst < /etc/prometheus/prometheus.yml.template > /etc/prometheus/prometheus.yml
