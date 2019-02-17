FROM debian:latest

ENV IN_DOCKER "true"
ENV SERVER_COUNT ""

ADD ping_russia.sh ping_russia.sh
ADD servers.txt servers.txt

RUN apt-get update && apt-get install -y traceroute xz-utils bash && rm -rf /var/lib/apt/lists/* && mkdir /working_dir /from_russia_with_love_comp && chmod +x ping_russia.sh

ARG ServerIP

VOLUME /from_russia_with_love_comp

ENTRYPOINT ["/bin/bash", "-c", "/ping_russia.sh $SERVER_COUNT"]
