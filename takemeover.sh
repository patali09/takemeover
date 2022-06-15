#!/usr/bin/bash -
figlet takeoverme
echo "                                                  By patali009"
if [ $1=="-d" ]
then
    nslist=$(dig NS $2 +short) #getting list of nameserver
    for ns in ${nslist/ / '\n'} #nslist is in a single line so making it in multiple line by replacing space with \n
    do
        echo $ns
        if [ $(host -t ns $2 $ns | grep "REFUSED") ] #checking if response contains refused
        then
            echo $"host -t ns $2 $ns | grep 'REFUSED'"
            echo "$2 with cname $ns is vulnerable"
        fi
    done
fi
if [ $1=="-f" ]
then
    while IFS= read -r line || [ -n "$line" ] #reading file including last line
    do
        nslist=$(dig NS $line +short)
        for ns in ${nslist/ / '\n'}
        do
            echo $ns
            if [ $(host -t ns $line $ns | grep "REFUSED") ]
            then
                echo $"host -t ns $line $ns | grep 'REFUSED'"
                echo "$line with cname $ns is vulnerable"
            fi
        done
    done < "$2"
fi