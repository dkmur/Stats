from mariadb:10.5

ENV PATH_TO_STATS=/stats/

COPY . $PATH_TO_STATS

RUN apt-get update && \
    apt install cron curl wget jq -y && \
    apt-get clean

WORKDIR $PATH_TO_STATS

ENTRYPOINT /stats/entrypoint.sh
