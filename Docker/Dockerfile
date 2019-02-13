FROM debian:latest
ADD ping_russia_docker.sh /frwl/ping_russia.sh
RUN apt-get update && apt-get install -y traceroute xz-utils bash && rm -rf /var/lib/apt/lists/* && mkdir /working_dir /from_russia_with_love_comp && chmod +x /frwl/ping_russia.sh
ARG ServerIP
VOLUME /from_russia_with_love_comp
ENTRYPOINT ["/bin/bash", "-c", "/frwl/ping_russia.sh $ServerIP"]
