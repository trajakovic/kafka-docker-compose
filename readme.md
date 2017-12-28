# Kafka 1.0.0 docker-compose with scaling options

_Inspired by [wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker), 
but probably cleaner and works with Apache Kafka 1.0.0 and multibroker (out of the box)_

## Why

 1. many config out in wild didn't work
 1. many config out in wild used custom (docker) images, hard to customize
 
I've addressed both issue

## Requirement

 * docker --version (tested with 17.06.0-ce)
 * docker-compose --version (tested with  1.14.0)

## Quick-start

Update HOST_IP_ADDRESS environment variable in docker-compose.yml, usually with result from `docker-machine ip default` or
with **real** IP address (on linux) `hostname -I` (skip 172.x.x.x they are (mostly) from docker networks).

Run with `docker-compose up` (single broker) or with `docker compose up --scale kafka=3` (three brokers). 

## Kafka configuration (server.properties)

List of properties found at [Broker Configs](https://kafka.apache.org/documentation/#brokerconfigs)

There are 2 levels of configuration:

 1. docker(-compose) environment variables starting with prefix **KAFKA_** are translated to Kafka's broker config, 
 ie. `KAFKA_ZOOKEEPER_CONNECT: myzookeeper:2375` is translated to `zookeeper.connect=myzookeeper:2375` property inside server.properties
 2. scripts mounted on path `/runtime/kafka/extras` could `export KAFKA_SOME_ENV_VARIABLE` and then those variables are merged into
 server.properties
    * they're executed in alphabetical order (chaining is possible)
    * exported environment variables will override same variables declared in docker(-compose) environment
    * see examples in repo: [/runtime/kafka/extras](https://github.com/trajakovic/kafka-docker-compose/tree/master/kafka/extras)

## Run

Run single broker

 * `docker-compose up`

Example with 3 kafka brokers:

 * `docker-compose up --scale kafka=3`
   * when started, find out kafka broker port on host with `docker-compose ps kafka` and use (one of, any) 
   
  
## Testing cluster with kafka tools - easy mode

_From [kafka.apache.org/quickstart](https://kafka.apache.org/quickstart)_

 * Run kafka with 3 or more brokers: `docker-compose up --scale kafka=3`
 * [Download and extract Kafka](https://www.apache.org/dyn/closer.cgi?path=/kafka/1.0.0/kafka_2.11-1.0.0.tgz)
 * for easier command use, set shell variables with zookeeper and kafka brokers ip:ports (run this from root of this project since it needs docker-compose.yml):
    * `ZOOKEEPER=_PUT_YOUR_DOCKER_MACHINE_OR_HOST_IP_:2181`
    * `BROKER_LIST=$(docker-compose ps -q kafka|xargs docker inspect --format='{{range $index, $value := .Config.Env}}{{if eq (index (split $value "=") 0) "HOST_IP_ADDRESS" }}{{range $i, $part := (split $value "=")}}{{if gt $i 1}}{{print "="}}{{end}}{{if gt $i 0}}{{print $part}}{{end}}{{end}}{{end}}{{end}}:{{ (index (index .NetworkSettings.Ports "9092/tcp") 0).HostPort}}'|paste -sd "," -)`
 * verify content of variables: `echo $ZOOKEEPER && echo $BROKERS_LIST`
 * in same shell move to kafka folder and continue with (Step 3 of) quickstart
 * **create topic**
   * `bin/kafka-topics.sh --zookeeper $ZOOKEEPER --create --replication-factor 1 --partitions 1 --topic test`
     * if you got `Exception in thread "main" org.I0Itec.zkclient.exception.ZkException: Unable to connect to XXX.XXX.XX.XXX:2181`
     you're probably pointing to wrong IP address (or port), see **Quick-start** above
 * **list topics**
   * `bin/kafka-topics.sh --zookeeper $ZOOKEEPER --list`
 * **send messages (from console)**
   * `bin/kafka-console-producer.sh --broker-list $BROKER_LIST --topic test`
 * **receive messages (from console)**
   * _don't forget to set $ZOOKEEPER and $BROKER_LIST variables if you opened new console_
   * `bin/kafka-console-consumer.sh --bootstrap-server $BROKER_LIST --topic test --from-beginning`
     * if you got `[2017-12-28 12:59:05,800] WARN [Producer clientId=console-producer] Connection to node -1 could not be established. Broker may not be available. (org.apache.kafka.clients.NetworkClient)`
     you're probably set wrong `HOST_IP_ADDRESS` in `docker-compose.yml` file
