#!/bin/bash

set -ex

config=/etc/icingaweb2
if [ ! -e "$config"/config.ini ]; then
    echo "Setting setup token from ICINGAWEB_SETUP_TOKEN"
    echo "$ICINGAWEB_SETUP_TOKEN" > "$config"/setup.token
fi

# render config file templates
for f in $(find /etc/icingaweb2/ -type f -name "*.j2"); do
		echo -e "Evaluating template\n\tSource: $f\n\tDest: ${f%.j2}"
		j2 $f > ${f%.j2}
		rm -f $f
done


# TODO: check for virtualbox based docker environments
echo "fixing permissions in $config"
chgrp -R www-data "$config"
find "$config" -type d -exec chmod g+ws {} \;
find "$config" -type f -exec chmod g+w {} \;

exec "$@"
