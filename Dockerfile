FROM rakudo-star:2024.10-alpine

WORKDIR /opt/representer
COPY . .
ENTRYPOINT ["/opt/representer/bin/run.sh"]
