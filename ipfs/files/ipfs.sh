#!/usr/bin/env bash

if [ -f /etc/sysconfig/ipfs ]
then
   source /etc/sysconfig/ipfs
fi

export IPFS_PATH

exec /opt/ipfs/go-ipfs/ipfs "$@"
