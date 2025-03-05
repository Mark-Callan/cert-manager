#!/usr/bin/env bash

domain_file=${1:?"One positional argument, domain file, required."}

test -f ${domain_file} || (echo "[ERROR] domain file doesn't exist: ${domain_file}" ; exit 1)

echo "config: ${domain_file}"
for domain in `cat ${domain_file}`; do
	echo " - ${domain}"
	domain_args="-d ${domain} ${domain_args}";
done


docker run \
	-it \
	-e "DOMAINS=${domain_args}" \
	-v ./target/certs:/etc/letsencrypt:rw \
	cert-manager:local

