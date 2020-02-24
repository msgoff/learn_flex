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
    python-dev \
    nginx \
    postgresql \
    python3-setuptools \
    libnginx-mod-nchan \
    curl \
    python3-pip \
    libnginx-mod-nchan \
    redis-server


RUN mkdir /var/www/html/bob
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install nodejs

RUN pip3 install -r requirements.txt
RUN cp default /etc/nginx/sites-available/default
RUN cp nginx.conf /etc/nginx/nginx.conf
RUN cp index.html /var/www/html/bob/index.html
RUN service nginx stop
RUN service nginx start
RUN service redis-server start
RUN pip3 install jupyter
RUN pip3 install pandas

WORKDIR /opt/