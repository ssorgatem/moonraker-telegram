#!/bin/bash
MYDIR_STATE=`dirname $0`
DIR_STATE="`cd $MYDIR_STATE/../; pwd`"

. $DIR_STATE/telegram_config.sh
. $DIR_STATE/scripts/state_config.txt

print_state_read=$(grep -oP '(?<="state": ")[^"]*' $DIR_STATE/webhsocket_state.txt)

	if [ "$print_state_read" = "printing" ]; then
        if [ "$print_state" = "0" ]; then
            sed -i "s/print_state=.*$/print_state="1"/g" $DIR_STATE/scripts/state_config.txt
            sh $DIR_STATE/scripts/telegram.sh "1"
            sleep 10
            if [ "$time" -gt "0" ]; then
            sed -i "s/time_pause=.*$/time_pause="0"/g" $DIR_STATE/scripts/time_config.txt
	        sed -i "s/time_msg=.*$/time_msg="1"/g" $DIR_STATE/scripts/time_config.txt
            sh $DIR_STATE/scripts/time_msg.sh &
            fi
        fi
        if [ "$pause" = "1" ]; then
            sed -i "s/pause=.*$/pause="0"/g" $DIR_STATE/scripts/state_config.txt
            sed -i "s/time_pause=.*$/time_pause="0"/g" $DIR_STATE/scripts/time_config.txt
        fi


    elif [ "$print_state_read" = "complete" ]; then
	    if [ "$print_state" = "1" ]; then
            sed -i "s/print_state=.*$/print_state="0"/g" $DIR_STATE/scripts/state_config.txt
            sed -i "s/time_msg=.*$/time_msg="0"/g" $DIR_STATE/scripts/time_config.txt
            sh $DIR_STATE/scripts/telegram.sh "2"
        fi

    elif [ "$print_state_read" = "paused" ]; then
        if [ "$print_state" = "1" ]; then
            if [ "$pause" = "0" ]; then
            sed -i "s/pause=.*$/pause="1"/g" $DIR_STATE/scripts/state_config.txt
            sed -i "s/time_pause=.*$/time_pause="1"/g" $DIR_STATE/scripts/time_config.txt
            sh $DIR_STATE/scripts/telegram.sh "3"
            fi
        fi     
    
    elif [ "$print_state_read" = "error" ]; then
        if [ "$print_state" = "1" ]; then
            sed -i "s/print_state=.*$/print_state="0"/g" $DIR_STATE/scripts/state_config.txt
            sed -i "s/time_msg=.*$/time_msg="0"/g" $DIR_STATE/scripts/time_config.txt
            sh $DIR_STATE/scripts/telegram.sh "4"
        fi

    elif [ "$print_state_read" = "standby" ]; then
	    sed -i "s/print_state=.*$/print_state="0"/g" $DIR_STATE/scripts/state_config.txt
        sed -i "s/time_msg=.*$/time_msg="0"/g" $DIR_STATE/scripts/time_config.txt
        sed -i "s/time_pause=.*$/time_pause="0"/g" $DIR_STATE/scripts/time_config.txt
    fi


sleep 1
done