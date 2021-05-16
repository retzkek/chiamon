FROM grafana/promtail:2.0.0
ARG prometheus_ip=prometheus
ARG loki_ip=loki
ENV ENV_PROMETHEUS_IP=${prometheus_ip}
ENV ENV_LOKI_IP=${loki_ip}

USER root
RUN apt update && apt install gettext -y && rm -rf /var/lib/apt/lists/*
COPY promtail.yaml /etc/promtail/config.yml.template
RUN envsubst < /etc/promtail/config.yml.template > /etc/promtail/config.yml
