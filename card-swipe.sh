#!/bin/bash
#Used for scanning track one of stripe cards 
source ./card-functions.sh # calls functions file

echo -e "\033[1;37m" #Set Bold white color
read -s -p "Swipe your Card:" "rawCard" #Ask for user input
echo -e "\033[0;37m" #echo new line for following text to be printed on next line and re-set color

#Regex for card
regexpres='%([A-B])' #Checks for "%" and first charater
regexpres+='([0-9]+)\^' #Check for first card number
regexpres+='([A-Z0-9 /?]+)\^' #Check for Name on Card
regexpres+='([0-9]{4})' #Check for expiration date
regexpres+='([0-9]{3})' #Check Service code
regexpres+='([0-9A-Z ]+)\?' #Check Discretionary Data and "?"

runCardData

./card-swipe.sh #restarts the script for batch proccessing
