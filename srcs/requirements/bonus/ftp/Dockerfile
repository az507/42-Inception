FROM debian:11

RUN apt-get update && apt-get install -y vsftpd vim #&& rm -rf /var/lib/apt/lists/*
RUN mkdir /tools
COPY tools/entrypoint.sh /tools
EXPOSE 21
WORKDIR /srv/ftp
VOLUME /var/log
VOLUME /srv/ftp
STOPSIGNAL SIGKILL

RUN groupadd -g 1000 achak && useradd -u 1000 --home /srv/ftp -g achak achak
#RUN --mount=type=secret,id=ftp_password,env=FTP_PASS \
#RUN --mount=type=secret,id=ftp_password,target=/run/secrets/ftp_password \
#ls -al /run/secrets/ftp_password
#ARG FTP_PASS1
#RUN echo "achak:${FTP_PASS1} | chpasswd"
#RUN groupmod -g 1000 ftp && usermod -u 1000 ftp && chmod 777 /srv/ftp
# MUST CREATE THIS DIRECTORY, vsftpd.conf file asks for the value of 'secure_chroot_dir' to be the name of an empty directory that the ftp user
# should not have write permissions to it. Without this, the daemon/docker container will immediately terminate upon the first connection it
# receives with $? = 137
RUN mkdir -p /var/run/vsftpd/empty && chmod a-w /var/run/vsftpd/empty && cp /etc/vsftpd.conf /tools/temp.conf
RUN chown -R achak:achak /srv/ftp
RUN chmod a+rwx /srv/ftp && echo "achak:password" | chpasswd
#RUN chown -R achak:achak /usr/sbin/vsftpd /var/log /var/run/vsftpd/empty /etc/vsftpd.conf /tools #/srv/ftp

#USER achak
#RUN chmod 777 /srv/ftp
CMD ["/tools/entrypoint.sh"]
