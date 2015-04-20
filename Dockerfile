FROM resin/rpi-raspbian
MAINTAINER abresas@resin.io

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables
    
# Install Docker from Docker Inc. repositories.
COPY ./rce /usr/bin/rce
CHMOD u+x /usr/bin/rce

# Install the magic wrapper.
ADD ./wraprce /usr/local/bin/wraprce
RUN chmod +x /usr/local/bin/wraprce

RUN curl -L https://github.com/hypriot/compose/releases/download/1.1.0-raspbian/docker-compose-Linux-armv7l > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN echo "#!/bin/bash\nDOCKER_HOST=unix:///var/run/rce.sock /usr/local/bin/docker-compose $@" > /usr/bin/docker-compose
RUN chmod +x /usr/bin/docker-compose

RUN mkdir /app
COPY ./app1 /app/app1
COPY ./app2 /app/app2
COPY ./docker-compose.yml /app/docker-compose.yml
WORKDIR /app

# Define additional metadata for our image.
VOLUME /var/lib/rce
CMD ["wraprce"]
