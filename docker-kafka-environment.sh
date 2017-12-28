export BROKER_LIST=$(docker-compose ps -q kafka|xargs docker inspect --format='{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}:{{(index (index .NetworkSettings.Ports "9092/tcp") 0).HostPort}}'|paste -sd "," -)
export ZOOKEEPER=$(docker-compose ps -q zookeeper|xargs docker inspect --format='{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}:{{(index (index .NetworkSettings.Ports "2181/tcp") 0).HostPort}}'|head -n1)

if [ -z ${BROKER_LIST+x} ]; then
    echo "Warning! \$BROKER_LIST is empty"
    exit 1
fi

if [ -z ${ZOOKEEPER+x} ]; then
    echo "Warning! \$ZOOKEEPER is empty"
    exit 2
fi


echo "Environment variables set:"
echo "  \$BROKER_LIST=${BROKER_LIST}"
echo "  \$ZOOKEEPER=${ZOOKEEPER}"
echo ""
echo "Now you can use (from this shell) kafka-cli, ie:"
echo "  \$KAFKA_HOME/bin/kafka-topics.sh --zookeeper \$ZOOKEEPER --create --replication-factor 1 --partitions 1 --topic test"
echo "  \$KAFKA_HOME/bin/kafka-topics.sh --zookeeper \$ZOOKEEPER --list"
echo "  \$KAFKA_HOME/bin/kafka-topics.sh --zookeeper \$ZOOKEEPER --describe --topic test"
echo ""
echo "  \$KAFKA_HOME/bin/kafka-console-producer.sh --broker-list \$BROKER_LIST --topic test"
echo ""
echo "  \$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server \$BROKER_LIST --topic test --from-beginning"
