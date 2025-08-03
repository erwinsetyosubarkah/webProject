# Menggunakan image dasar nginx
FROM nginx:latest

# Salin file HTML ke direktori default nginx
COPY html/index.php /var/www/pegawai-baru/index.php

COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf

COPY etc/nginx/sites-available/pegawai-baru.test.conf /etc/nginx/sites-available/pegawai-baru.test.conf

RUN mkdir /etc/nginx/sites-enabled/

RUN ln -s /etc/nginx/sites-available/pegawai-baru.test.conf /etc/nginx/sites-enabled/pegawai-baru.test.conf