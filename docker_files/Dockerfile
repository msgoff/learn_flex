# https://docs.docker.com/engine/reference/builder/#from
# https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:0.11

# https://docs.docker.com/engine/reference/builder/#run
RUN apt-get update && \
    apt-get install -y \
    flex \
    bison \
    gcc \
    git \ 
    make \
    graphviz \
    python3-dev \
    python-dev 

WORKDIR /opt/

RUN git clone https://github.com/msgoff/learn_flex.git

WORKDIR /opt/learn_flex/
