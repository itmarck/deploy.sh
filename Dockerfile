FROM ubuntu:20.04

# Update and install curl and git
RUN apt-get update && apt-get install -y curl && apt-get install -y git

# Run the install script from github
RUN curl https://raw.githubusercontent.com/itmarck/deploy.sh/main/install.sh | bash

ENTRYPOINT ["/bin/bash"]
