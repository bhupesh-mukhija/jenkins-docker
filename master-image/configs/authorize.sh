#!/bin/bash
#exit if any command fails
set -e
#load config file
source /etc/configs/auth/config.sh
#source config.sh

#set IFS to split string by ;
IFS=";"

cmd_auth=""
addOption() {
	if
		[ -n "$2" ]
    	then
	    	cmd_auth+="$1$2 "
	else
		cmd_auth+="$1 "
    	fi
}

for eachOrg in "${AUTH_ORG[@]}"
do
	read -ra eachOrgProp <<< "$eachOrg"
	if 
		[ ${eachOrgProp[0]} == "sfdxurl" ]
	then
		cmd_auth="sfdx force:auth:sfdxurl:store "
		addOption "--sfdxurlfile=" ${eachOrgProp[1]}
		addOption "--setalias=" ${eachOrgProp[2]}
		if
			[ -n ${eachOrgProp[3]} ]
		then
			addOption ${eachOrgProp[3]}
		fi
		if
                        [ -n ${eachOrgProp[4]} ]
                then
                        addOption ${eachOrgProp[4]}
                fi
		echo $cmd_auth
		eval $cmd_auth
	else 
		if
			[ ${eachOrgProp[0]} == "jwt" ]
		then
			cmd_auth="sfdx force:auth:jwt:grant "
			read -ra eachOrgProp <<< "$eachOrg"
			addOption "--username=" ${eachOrgProp[1]}
			addOption "--instanceurl=" ${eachOrgProp[2]}
			addOption "--setalias=" ${eachOrgProp[3]}
			addOption "--clientid=" ${eachOrgProp[4]}
			addOption "--jwtkeyfile=" ${eachOrgProp[5]}
                        
			if	[ -n ${eachOrgProp[6]} ]
                	then
                        	addOption ${eachOrgProp[6]}
                	fi
                	if
                        	[ -n ${eachOrgProp[7]} ]
               		then
                        	addOption ${eachOrgProp[7]}
                	fi
			echo $cmd_auth
			eval $cmd_auth
		else 
			echo "Type of authentication missing in config, it should be either sfdxurl or jwt" 
		fi
	fi
done
exec "$@"
