#!/bin/bash
CURDIR=$(dirname $0)
cd "$CURDIR"

Process="node"
counter=0

function terminate {

	kill -SIGTERM $PROC1 2>/dev/null
	echo -e "\e[33m\n\n"
	echo -e "-----------------------------"
	echo -e "       VALVE TERMINATED.     "
	echo -e "-----------------------------"
	echo -e "\n\n"
	trap SIGTERM
	trap SIGINT
	kill -SIGTERM $$ 2>/dev/null
	}

trap terminate SIGINT
# trap 'echo int; kill -SIGINT $PROC1' SIGINT
trap terminate SIGTERM



function looping {
	while true; do
	  echo -e "\e[34m"
	  echo "-----------------------------"
	  echo "       Starting nodejs.      "
	  echo "-----------------------------"
	  echo ""
	  echo ""

		amixer -c 1 set Speaker 78%

		./socatcleaner.sh
		./cleanup.sh
		DISPLAY=:1 node index.js &
		PROC2=$!
		trap 'kill -SIGINT $PROC2; trap SIGINT; break' SIGINT
		trap 'kill -SIGINT $PROC2; trap SIGTERM; break' SIGTERM
		wait
		echo ""
	  counter=$(expr $counter + 1)

	  echo "Error. Retrying. Rerun #$counter."

		if [[ $counter -eq 10 ]]; then
				echo "something's really up."
				sudo reboot
		fi
	  echo  ""
	  sleep 5
	done
}

looping &
PROC1=$!
wait
