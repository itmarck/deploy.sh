FROM ubuntu:20.04

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y vim
RUN apt-get install -y curl

RUN bash install.sh

ENTRYPOINT ["/bin/bash"]
