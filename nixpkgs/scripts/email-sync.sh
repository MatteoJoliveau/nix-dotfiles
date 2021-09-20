#!/usr/bin/env bash

export NOTMUCH_CONFIG="$HOME/.config/notmuch/notmuchrc"
MAIL_ACCOUNT="Personal"
MAILDIR="$HOME/.mail/$MAIL_ACCOUNT"
pull=false

params="$(getopt -o p -l pull --name "$0" -- "$@")"
eval set -- "$params"

while true
do
    case "$1" in
        -p|--pull)
            pull=true
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            break
            ;;
    esac
done

if [ "$pull" = true ]; then
    mbsync --all --pull
fi

notmuch new --no-hooks

afew --all --move-mails -v
afew --all --tag -v

unread=$(notmuch count --output=files tag:unread AND tag:inbox)
email="emails"
if [ "$unread" = 1 ]; then
    email="email"
fi

# Uncomment to enable email notifications
# if [ "$unread" -gt 0 ]; then
#   notify-send "You have $unread new $email" --category=email.arrived
# fi

echo You have "$unread" new "$email"

# Refresh alot's interface
pkill -USR1 alot
