#!/bin/sh

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server
service apache2 stop 


# SHINY USER AND PASSWORD IN ENV 
if [ "$SHINY_USER" -a "$SHINY_PASSWORD" ]; then
  sed -i -r 's/3838/11111/' /etc/shiny-server/shiny-server.conf
  a2enmod proxy
  a2enmod proxy_http
  a2enmod proxy_connect
  htpasswd -cb /etc/.htpasswd $SHINY_USER $SHINY_PASSWORD
  service apache2 restart
fi


exec shiny-server >> /var/log/shiny-server.log 2>&1
