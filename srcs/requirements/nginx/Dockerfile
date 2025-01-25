FROM debian:11

RUN apt-get update -y && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*
RUN mkdir /var/lib/nginx/body && touch /run/nginx.pid
RUN groupadd -r -g 1000 nginx && useradd -u 1000 -r -g nginx nginx
COPY conf/nginx.conf /etc/nginx
COPY conf/server.conf /etc/nginx/conf.d
RUN chown -R nginx:nginx /var/www/html /etc/nginx /var/lib/nginx /run/nginx.pid
WORKDIR /var/www/html
#VOLUME /var/www/html
USER nginx
CMD ["nginx", "-g", "daemon off;"]
