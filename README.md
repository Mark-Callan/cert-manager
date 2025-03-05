# Cert Manager

Generate letsencrypt certs with certbot with cloudflare.

## Docker Image

Build the docker image with 

    make docker

## Credentials

A credential file is created in the target directory containing the cloudflare API key. The default location of the source key is in /data/files/cloudflare/apitoken To override this set the API_TOKEN_FILE environment variable when building the docker image.

    API_TOKEN_FILE=/some/path/apitoken make docker


## Configuring Domains

Create a domain entry in the domains directory containing a space delimited list of domains.

To create certs for srvr.farm including all wildcards

    >cat domains/srvr.farm
    srvr.farm *.srvr.farm

## Generate the certs

Certs will be generated for all the domains in the domain directory. To generate the certs, use the certs target.

    make certs


Or you can do everything in one shot.

    make all

## Output

The output is placed in the target directory at target/certs

    >ls -l target/certs
    total 4
    drwx------ 3 root root  42 Mar  5 21:55 accounts/
    drwx------ 3 root root  23 Mar  5 21:56 archive/
    drwx------ 3 root root  37 Mar  5 21:56 live/
    -rw-r--r-- 1 root root 740 Mar  5 21:54 README
    drwxr-xr-x 2 root root  28 Mar  5 21:56 renewal/
    drwxr-xr-x 5 root root  43 Mar  5 21:55 renewal-hooks/
    drwxr-xr-x 2 root root  93 Mar  5 21:54 srvr.farm/

## Install

To install the scripts locally, use the install target. Note, this needs to be done as root.

    sudo make install 

## Cleanup

To cleanup old build files, use the clean target. Note that the scripts are created as the root user, so they need to be cleaned as root.

    sudo make clean
