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
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/lib/nginx/body /tools \
&& touch /run/nginx.pid /var/log/nginx/access.log /var/log/nginx/error.log #/run/secrets/ssl_cert /run/secrets/ssl_cert_key
RUN groupadd -r -g 1001 nginx && useradd -u 1001 -r -g nginx nginx
COPY conf/nginx.conf /etc/nginx
COPY conf/server.conf /etc/nginx/conf.d
#VOLUME /home/nginx
RUN chown -R nginx:nginx /var/www/html /etc/nginx /var/lib/nginx /run/nginx.pid /var/log/nginx #/run/secrets
WORKDIR /var/www/html
#VOLUME /var/www/html
USER nginx
#CMD ["sleep", "infinity"]
CMD ["nginx", "-g", "daemon off;"]
