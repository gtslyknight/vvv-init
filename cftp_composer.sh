#!/bin/bash
# 
# Wrapper to allow easily adding the relevant keys and updating
# or installing from Composer.

# Reset all variables that might be set
COMPOSER_COMMAND=""
COMPOSER_NO_DEV=""
REQUIRE_SUDO=true

while [ $# -gt 0 ]
do
	case "$1" in
		--no-sudo)
			REQUIRE_SUDO=""
			echo "Sudo not required"
			shift
			;;
		update)
			COMPOSER_COMMAND="update"
			echo "Composer update command, will get new packages as specified in composer.json"
			shift
			;;
		install)
			COMPOSER_COMMAND="install"
			echo "Composer install command, will install all packages specified in composer.lock"
			shift
			;;
		--no-dev)
			COMPOSER_NO_DEV="--no-dev"
			echo "Got '--no-dev' switch, composing for production environment"
			shift
			;;
		--) # End of all options
				shift
				break
				;;
		*)
			echo "WARN: Unknown option (ignored): $1" >&2
			shift
			;;
		*)  # no more options. Stop while loop
				break
				;;
	esac
done

if [ $REQUIRE_SUDO ] && [ `whoami` != root ]; then
	echo "ERROR: Please run this script as root or using sudo"
	exit 3
fi

if [ ! $COMPOSER_COMMAND ]; then
	echo "Could not find a recognised composer command, only 'update' and 'install' currently work with this script."
	exit 4
fi

ssh-agent bash -c "ssh-add ssh/cftp_deploy_id_rsa; composer $COMPOSER_COMMAND $COMPOSER_NO_DEV --verbose;"

exit 0
