FROM ubuntu:24.04

RUN apt update && apt upgrade -y

RUN apt install -y certbot python3-certbot-dns-cloudflare

COPY credentials.ini /etc/credentials.ini
RUN chmod 600 /etc/credentials.ini
RUN mkdir /certbot
WORKDIR /certbot

CMD [ "/bin/sh", "-c", "certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/credentials.ini --dns-cloudflare-propagation-seconds 60 ${DOMAINS} --non-interactive --expand --agree-tos --email mark.l.callan@gmail.com"]


