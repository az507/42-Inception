FROM debian:11

RUN apt-get update && apt-get upgrade -y && apt-get install -y redis host && rm -rf /var/lib/apt/lists/*
#COPY conf/redis.conf /etc/redis
WORKDIR /etc/redis
#VOLUME /var/log/redis
RUN mkdir /tools && touch /var/log/redis/cache.log
COPY tools /tools
# redis user and group has already been created automatically, so just change uid and gid to match my current user on host machine
RUN usermod -u 1004 redis && groupmod -g 1004 redis
RUN chown -R redis:redis /etc/redis /var/log/redis /tools
USER redis
CMD ["/tools/entrypoint.sh"]
