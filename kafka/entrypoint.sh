#!/usr/bin/env bash

for f in /runtime/kafka/extras/*.env; do
    echo "Sourcing file $f"
    source ${f};
done

mkdir /runtime/logs${CONTAINER_NAME}
mkdir /runtime/kafka${CONTAINER_NAME}

java -jar /usr/local/lib/kafka-helper/property-configurer.jar ${HOME_LOCATION}/config/server.properties > /runtime/kafka${CONTAINER_NAME}/server.properties

echo "Merged server.properties:"
cat /runtime/kafka${CONTAINER_NAME}/server.properties
exec ${HOME_LOCATION}/bin/kafka-server-start.sh /runtime/kafka${CONTAINER_NAME}/server.properties
