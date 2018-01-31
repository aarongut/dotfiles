#!/bin/sh
USER=$1

if [ -z $USER ]; then
	USER=$EMAIL
fi

PWORD=$(security find-generic-password -a "$USER" -s mutt-gmail -w)

echo "set imap_user=\"$USER\""
echo "set imap_pass=\"$PWORD\""
