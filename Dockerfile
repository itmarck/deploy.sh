FROM ubuntu:20.04

WORKDIR /app

# Update and install curl
RUN apt-get update && apt-get install -y curl

# Run the install script from github
RUN curl https://raw.githubusercontent.com/itmarck/deploy.sh/main/install.sh | bash

ENTRYPOINT ["/bin/bash"]
