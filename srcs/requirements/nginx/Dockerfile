FROM debian:11

# Create root Certificate Authority(CA) key and cert which will be used to sign out ssl cert
#openssl req -x509 -sha256 -nodes -newkey rsa:2048 -keyout ca.key -out ca.crt

# Create server rsa key
#openssl genrsa -out host.key 2048

# Create Certificate Signing Request(CSR) and fill in the blanks
#openssl req -new -key host.key -out host.csr

# Create self-signed ssl cert with self-signed CA cert
#openssl x509 -req -in host.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out host.crt -sha256

# Can use make-ssl-cert command from ssl-cert package to create self-signed certs
RUN apt-get update -y && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*
RUN mkdir /var/lib/nginx/body && touch /run/nginx.pid
RUN groupadd -r -g 1000 nginx && useradd -u 1000 -r -g nginx nginx
COPY conf/nginx.conf /etc/nginx
COPY conf/server.conf /etc/nginx/conf.d
RUN chown -R nginx:nginx /var/www/html /etc/nginx /var/lib/nginx /run/nginx.pid
WORKDIR /var/www/html
#RUN chmod 757 /var/www/html
#VOLUME /var/www/html
USER nginx
CMD ["nginx", "-g", "daemon off;"]
