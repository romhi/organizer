#!/bin/bash
### BEGIN INIT INFO
# Provides:          APPLICATION
# Required-Start:    $all
# Required-Stop:     $network $local_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start the APPLICATION unicorns at boot
# Description:       Enable APPLICATION at boot time.
### END INIT INFO
# 
# Use this as a basis for your own Unicorn init script.
# Change APPLICATION to match your app.
# Make sure that all paths are correct.

set -u
set -e

# Change these to match your app:

APP_ROOT="/home/deployer/apps/puheet/current"
PID="home/deployer/apps/puheet/current/tmp/pids/unicorn.pid"
ENV=production

GEM_HOME="/home/deployer/.rvm/gems/ruby-2.2.3"

UNICORN_OPTS="-D -E $ENV -c $APP_ROOT/config/unicorn/$ENV.rb"

SET_PATH="cd $APP_ROOT; rvm use 2.2.3"
CMD="$SET_PATH; RAILS_ENV = $ENV bundle exec unicorn $UNICORN_OPTS"


old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

sig () {
	test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
	test -s $old_pid && kill -$1 `cat $old_pid`
}

case ${1-help} in
start)
	sig 0 && echo >&2 "Already running" && exit 0
	su - unicorn -c "$CMD"
	;;
stop)
	sig QUIT && exit 0
	echo >&2 "Not running"
	;;
force-stop)
	sig TERM && exit 0
	echo >&2 "Not running"
	;;
restart|reload)
	sig HUP && echo reloaded OK && exit 0
	echo >&2 "Couldn't reload, starting '$CMD' instead"
	su - unicorn -c "$CMD"
	;;
upgrade)
	sig USR2 && exit 0
	echo >&2 "Couldn't upgrade, starting '$CMD' instead"
	su - unicorn -c "$CMD"
	;;
rotate)
	sig USR1 && echo rotated logs OK && exit 0
	echo >&2 "Couldn't rotate logs" && exit 1
	;;
*)
 	echo >&2 "Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"
 	exit 1
 	;;
esac