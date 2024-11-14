# syntax=docker/dockerfile:1
FROM debian:11
WORKDIR /tmp
SHELL [ "/bin/bash", "-c" ]
# installing nginx from apt
RUN apt-get update
RUN apt-get install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
RUN apt-get install -y nginx
COPY index.html index.html
COPY cube-spinning.gif cube-spinning.gif
COPY nginx.conf /etc/nginx/nginx.conf
COPY logs/access.log /usr/local/nginx/logs/access.log
COPY logs/error.log /usr/local/nginx/logs/error.log
CMD [ "nginx", "-g", "daemon off;" ]
#EXPOSE 10000
#CMD [ "nginx", "-t" ]
#CMD [ "cat", "/etc/nginx/nginx.conf" ]
