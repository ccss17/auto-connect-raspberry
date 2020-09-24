#!/bin/bash
if [ -z $1 ] || [ -z $2 ]; then
    echo -e $R "Usage ./auto-connect.sh <INTERFACE> <SSH_ID>" $E > /dev/stderr
    exit 1
fi

R="\e[1;31m"
G="\e[1;32m"
B="\e[1;34m"
T="\e[1;35m"
E="\e[0m"

WEAK_IP_FILTER="([0-9]{1,3}\.){3}[0-9]{1,3}"
INTERFACE=$1
ID=$2
GATEWAY=$(ip route | grep default | grep -E -o $WEAK_IP_FILTER)
LOCAL=$(ip a show $INTERFACE | grep -E -o "inet $WEAK_IP_FILTER" | cut -d' ' -f2)
NETWORK=$(ip route | grep $GATEWAY -n1 | tail -n1 | grep -E -o $WEAK_IP_FILTER"/[0-9]{1,2}")

print_target_IPs()
{
    ADDR=$1
    printf "Target IPs: "
    for i in "${ADDR[@]}"; do
        if [[ $i != $GATEWAY ]] && [[ $i != $LOCAL ]]; then
            printf $R"%s "$E $i
        fi
    done
    echo
}

try_connect_ssh()
{
    ADDR=$1
    for i in "${ADDR[@]}"; do
        if [[ $i != $GATEWAY ]] && [[ $i != $LOCAL ]]; then
            echo -e $G"Connecting to "$B$i$G" with ID "$B$ID $E
            ssh $ID@$i 
            [[ $? = "0" ]] && exit 0 ||\
                echo -e $R"It is not your raspberry..."$E
        fi
    done
}

main()
{
    echo -e $G"Search raspberry in "$B$INTERFACE $E
    while true; do
        SCAN_RESULT=$(nmap -p22 --open $NETWORK)
        IP_LIST=$(grep -o -E $WEAK_IP_FILTER <<< $SCAN_RESULT)
        readarray -t ADDR <<<"$IP_LIST"
        print_target_IPs $ADDR
        try_connect_ssh $ADDR
    done
}

main