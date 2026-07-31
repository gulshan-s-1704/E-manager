#!/bin/sh
set -e

# Render sets PORT automatically (Free/Starter plans typically use 10000).
# Default to 8080 for local `docker run` testing.
PORT_TO_USE=${PORT:-8080}

echo "Configuring Tomcat to listen on port $PORT_TO_USE"
sed -i "s/port=\"8080\"/port=\"$PORT_TO_USE\"/" /usr/local/tomcat/conf/server.xml

exec catalina.sh run
