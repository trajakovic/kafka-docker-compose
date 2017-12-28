# Kafka 1.0.0 docker-compose with scaling options

## Config

Update HOST_IP_ADDRESS environment variable in docker-compose.yml, usually with result from `docker-machine ip default` or
with **real** IP address `hostname -I` (172.x.x.x are usually from docker networks so ignore those). 

## Run

Example with 3 kafka brokers:

 * `docker-compose up --scale kafka=3`
   * when started, find out kafka broker port on host with `docker-compose ps kafka` and use (one of, any) 



## Kafka brokers on host:


To list brokers (if `HOST_IP_ADDRESS` is correctly set)
 * `docker-compose ps -q kafka|xargs docker inspect --format='{{range $index, $value := .Config.Env}}{{if eq (index (split $value "=") 0) "HOST_IP_ADDRESS" }}{{range $i, $part := (split $value "=")}}{{if gt $i 1}}{{print "="}}{{end}}{{if gt $i 0}}{{print $part}}{{end}}{{end}}{{end}}{{end}}:{{ (index (index .NetworkSettings.Ports "9092/tcp") 0).HostPort}}'`
 
## Zookeeper on host:

To list zookeeper(s)
 * `docker compose ps zookeeper`