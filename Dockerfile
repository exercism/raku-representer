FROM rakudo-star:2024.04-alpine

WORKDIR /opt/representer
COPY . .
ENTRYPOINT ["/opt/representer/bin/run.sh"]
