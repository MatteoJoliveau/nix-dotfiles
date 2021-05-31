#!/usr/bin/env bash

MAIL_ACCOUNT="Personal"
MAILDIR="$HOME/.mail/$MAIL_ACCOUNT"
poll=false

# Move a message file while removing its UID-part
function safeMove { s=${1##*/}; s=${s%%,*}; mv -f $1 $2/$s; }

params="$(getopt -o p -l poll --name "$0" -- "$@")"
eval set -- "$params"

while true
do
    case "$1" in
        -p|--poll)
            poll=true
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

if [ "$poll" = true ]; then
    astroid --start-polling || true
fi

mbsync --all
notmuch new --no-hooks

unread=$(notmuch count --output=files tag:unread AND tag:inbox)
echo You have "$unread" new emails

# Move all deleted messages to the Trash folder
echo Moving $(notmuch count --output=files --exclude=false tag:deleted AND NOT folder:$MAIL_ACCOUNT/Trash) \
     deleted messages to the Trash folder
for i in $(notmuch search --exclude=false --output=files tag:deleted AND NOT folder:$MAIL_ACCOUNT/Trash); do
    safeMove $i "$MAILDIR/Trash/cur"
done

# Move all spam messages to the Spam folder
echo Moving $(notmuch count --output=files tag:spam AND NOT folder:$MAIL_ACCOUNT/Spam) \
     spam-marked messages to the Spam folder
for i in $(notmuch search --output=files tag:spam AND NOT folder:$MAIL_ACCOUNT/Spam); do
    safeMove $i "$MAILDIR/Spam/cur"
done

# Move all unarchived messages from Archive to Inbox folder
echo Moving $(notmuch count --output=files "folder:$MAIL_ACCOUNT/Archive AND tag:inbox OR tag:todo") \
     archived messages from Archive to Inbox folder
for i in $(notmuch search --output=files "folder:$MAIL_ACCOUNT/Archive AND tag:inbox OR tag:todo"); do
    s=${i##*/}; s=${s%%,*}; echo "$i -> $MAILDIR/Inbox/cur/$s"
    safeMove $i "$MAILDIR/Inbox/cur"
done

# Move all archived messages from Inbox to Archive folder
echo Moving $(notmuch count --output=files "folder:$MAIL_ACCOUNT/Inbox AND (NOT tag:inbox AND NOT tag:todo OR tag:archived)") \
     archived messages from Inbox to Archive folder
for i in $(notmuch search --output=files "folder:$MAIL_ACCOUNT/Inbox AND (NOT tag:inbox AND NOT tag:todo OR tag:archived)"); do
    safeMove $i "$MAILDIR/Archive/cur"
done

notmuch new --no-hooks
notmuch tag -archived +inbox folder:$MAIL_ACCOUNT/Inbox AND NOT tag:todo
notmuch tag -archived folder:$MAIL_ACCOUNT/Inbox AND tag:todo
notmuch tag +archived -inbox -unread folder:$MAIL_ACCOUNT/Archive

if [ "$poll" = true ]; then
    astroid --stop-polling || true
fi