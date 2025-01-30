#!/bin/bash

sed -i 's/listen=NO/listen=YES/g' /tools/temp.conf
sed -i 's/listen_ipv6=YES/listen_ipv6=NO/g' /tools/temp.conf
#sed -i 's/local_enable=YES/local_enable=NO/g' /tools/temp.conf
sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' /tools/temp.conf
sed -i 's/#write_enable=YES/write_enable=YES/g' /tools/temp.conf
sed -i 's/#anon_upload_enable=YES/anon_upload_enable=YES/g' /tools/temp.conf
sed -i 's/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g' /tools/temp.conf
#sed -i 's/#local_umask=022/local_umask=022/g' /tools/temp.conf
#sed -i 's/pam_service_name=vsftpd/pam_service_name=ftp/g' /tools/temp.conf
echo "hide_ids=yes" >> /tools/temp.conf
echo "anon_other_write_enable=YES" >> /tools/temp.conf
echo "seccomp_sandbox=NO" >> /tools/temp.conf
echo "pasv_min_port=40000" >> vsftpd.conf
echo "pasv_max_port=50000" >> vsftpd.conf
#sed -i 's/ssl_enable=NO/ssl_enable=yes/g' vsftpd.conf

# Replace with self-signed cert and private key for TLS/SSL
#sed -i 's@/etc/ssl/certs/ssl-cert-snakeoil.pem@'"/run/secrets/ssl_cert"'@' vsftpd.conf
#sed -i 's@/etc/ssl/private/ssl-cert-snakeoil.key@'"/run/secrets/ssl_cert_key"'@' vsftpd.conf

echo "chroot_local_user" >> /tools/temp.conf
echo "anon_root=/srv/ftp" >> /tools/temp.conf
#echo "local_root=/srv/ftp" >> /tools/temp.conf
echo "log_ftp_protocol=YES" >> /tools/temp.conf
echo "dual_log_enable=YES" >> /tools/temp.conf
echo "xferlog_std_format=YES" >> /tools/temp.conf
# vsftpd has to be run as root, else there will be security problems because chroot can't be used
# to restrict file access when this option below is set (even if launched by root)
#echo "run_as_launching_user=YES" >> /tools/temp.conf
cp /tools/temp.conf /etc/vsftpd.conf

while true;
do
    sleep 1
done
#chmod 757 /srv/ftp
vsftpd 2>&1

#FTP_PASS=$(cat /run/secrets/ftp_password)
#
#exec su achak -c "/usr/sbin/vsftpd" << EOF
#$FTP_PASS
#EOF
#
#echo "achak:$FTP_PASS" | chpasswd
#FTP_PASS=$(grep password "/run/secrets/ftp_credentials" | awk '{print $2}')
#echo "achak:$FTP_PASS" | chpasswd
#passwd achak << EOF
#
#$FTP_PASS
#EOF
#chown -R $FTP_USER:$FTP_USER /var/log /var/run/vsftpd/empty /etc/vsftpd.conf /tools
#su $FTP_USER << EOF
#$FTP_PASS
#EOF

#while true;
#do
#    sleep 1
#done

# Don't run the vsftpd with exec as standalone, when the connection closes the vsftpd process will
# immediately terminate -- run it as a child process
#exec su achak -c "/usr/sbin/vsftpd" << EOF
#$(cat /run/secrets/ftp_password)
#EOF
