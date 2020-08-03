
function parseCardNumber() { #defines function
	case ${1:0:1} in #checks the first character in variable $1
	[1]) #Airlines
		echo -e "\tAirline Card"
		;;
	[2]) #Airlines
		echo -e "\tAirline Card"
		;;
	[3]) #Travel Entertainment Cards #There are also gift cards with these numbers
		case ${1:1:1} in
		[4])
			echo -e "\tDinners Club" #OR Maybe AMEX
			;;
		[6])
			echo -e "\tDinners Club"
			;;
		[7])
			echo -e "\tAmerican Express"	
			echo -e "\tType and currency: ${1:2:2}" #FEATURE: Find out what this means
			echo -e "\tAccount Number: ${1:4:7}"
			echo -e "\tCheck Digit: ${1:11}"
			;;
		[8])
			echo "Carte Blanche or Dinners Club"
			;;
		esac
		;;
	[4]) #Banking and Financial Institutions Visa Cards
		echo -e "\tVisa Card"	
		echo -e "\tBank Number: ${1:0:6}"
		echo -e "\tAccount Number: ${1:6:9}"
		echo -e "\tCheck Digit: ${1:15}"
		;;
	[5]) #Banking and Financial Institutions Master Card
		case ${1:1:1} in
		[1-5])
			echo -e "\tMaster Card"	
			echo -e "\tBank Number: ${1:0:6}" #FEATURE: Bank Number length depends on the second digit and I have not yet implemented this completely
			echo -e "\tAccount Number: ${1:6:9}"
			echo -e "\tCheck Digit: ${1:15}"
			;;
		esac
		;;
	[6]) #Merchandising and Banking
		##FEATURE: Add Case for cards starting with 6011, 622126 to 622925, 644, 645, 646, 647, 648, 65
		##FEATURE: Add else statement saying most likely a Gift Card
		echo -e "\tThis is a discover Card of Gift Card"
		;;
	[7]) echo "Petroleum Companies" ;; #Petroleum Companies
	[8]) echo "Telecommunications Companies" ;; #Telecommunications Companies
	[9]) echo "National Assignment" ;; #National Assignment
	esac
}

function parseName() {
	#FEATURE: Use this function to extrapolate First Name, Last Name, and Middle initial
	echo -e "\tFirst Name: -"
	echo -e "\tMiddle Intial: -"
	echo -e "\tLast Name: -"
}

function expirationCheck() {
	if (( $(date --date="20$101" +"%s") > $(date +"%s") )) ; then
		echo -e "\t\033[0;32mCard is \033[1;32mnot\033[0;32m expired\033[0;37m"
	else
		echo -e "\t\033[0;31mCard is expired\033[0;37m"
	fi
}

function parseServiceCode() {
	if [ $1 = 110 ] ; then #Check if gift card and if so return gift card if not run Service Code
		echo "is Gift Card" #Service code 110 is seems to be a gift card service code
	else
	#Interchange
		case ${1:0:1} in #check the first character of variable $1
		[1]) echo -e "\tInternational interchange OK" ;;
		[2]) echo -e "\tInternational interchange, use IC (chip) where feasible" ;;
		[5]) echo -e "\tNational Interchange only except under bilateral agreement" ;;
		[6]) echo -e "\tNational Interchange only except under bilateral agreement, use IC (chip) where feasible" ;;
		[7]) echo -e "\tNo interchange except under bilateral agreement (closed loop)" ;;
		[9]) echo -e "\tTest" ;;
		esac
	#Authorization Processing
		case ${1:1:1} in #check the second character of variable $1
		[0]) echo -e "\tNormal" ;;
		[2]) echo -e "\tContact issuer via online means" ;;
		[4]) echo -e "\tContact issuer via online means except bilateral agreement" ;;
		esac
	#Allowed Services & PIN requirements
		case ${1:2:1} in #check the third character of variable $1
		[0]) echo -e "\tNo restrictionss, PIN required" ;;
		[1]) echo -e "\tNo Restrictions" ;;
		[2]) echo -e "\tGoods and services only (no cash)";;
		[3]) echo -e "\tATM only, PIN required" ;;
		[4]) echo -e "\tCash only" ;;
		[5]) echo -e "\tGoods and services only (no cash), PIN required" ;;
		[6]) echo -e "\tNo Restrictions, use PIN where feasible" ;;
		[7]) echo -e "\tGoods and services only (no cash), use PIN where feasible" ;;
		esac
	fi
#FEATURE: Add function to echo commands non-verbosly
#FEATURE: Label each Service code response
}
function runCardData() {
#FEATURE: create function for each title with change of color
	if [[ $rawCard =~ $regexpres ]]; then #compare card format against regex
		cardDetails=("${BASH_REMATCH[@]}") #assign data to cardDetails array

	#Track Format
		case ${cardDetails[1]} in
		[A])
			echo -e "\033[0;34mTrack Format:\033[0;37m A - Proprietary Format"
			;;
		[B])
			echo -e "\033[0;34mTrack Format:\033[0;37m B - Standard Format"
			;;
		esac
	#Card Number
		echo -e "\033[0;34mCard Number:\033[0;37m ${cardDetails[2]}"
		parseCardNumber ${cardDetails[2]} #uses function in file
	#Name on Card
		echo -e "\033[0;34mName on Card:\033[0;37m ${cardDetails[3]}" #Calls Function with parameter
		parseName ${cardDetails[3]}
	#Expiration Date
		echo -e "\033[0;34mExpiration Date:\033[0;37m $(date --date="20${cardDetails[4]}01" +"%B %Y")" #Uses "Year Month" output on card and formats date for the first of the month of the years 20XX
		expirationCheck ${cardDetails[4]}

	#Service Code
		echo -e "\033[0;34mService Code:\033[0;37m ${cardDetails[5]}"
		parseServiceCode ${cardDetails[5]} #uses function in file
	#Discretionary Data
		echo -e "\033[0;34mDiscretionary Data:\033[0;37m ${cardDetails[6]}"
		#FEATURE: Figure-out how to use this somehow

	else #Card does not match regex
		echo -e "\033[0;31minvalid card format\033[0;37m" #echo invalid - color red then reset color to white
		read -n 1 -p "Would you like to see the raw card data?(y/N): " "choice"
			if [[ $choice =~ [yY] ]]; then
				echo ""
				echo "$rawCard"
			else
				echo ""
			fi

	fi
}

##Feature: have a database of bank names and thier numbers where a bank name can be generated from the number
