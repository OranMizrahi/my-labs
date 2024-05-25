Run agent on container

There is two connection method I will mention. one is JNLP, that use java for connection and more comptabilite with plugins because its the one used only.
second is WebSocket that is more newer but have some comptabillite issue with some plugins.


There are three images options each one of them has cons and pros
1.The offical one, it's lightweight
The con's when trying to use docker in it, it will not work beacuse missing of systemd but you can mount docker.sock
Called jenkins/inbound-agent 
2.Improve of the offical one with docker build-in but able to use JNLP method for connection and has the abillity to run DIND and mount docker 
https://hub.docker.com/r/odavid/jenkins-jnlp-slave
3.Improve of the second image mention. The problem is when using docker-compose it use WebSocket only instead of JNLP but it have more features also.
https://hub.docker.com/r/jforge/jenkins-inbound-agent
cons


docker run --name <container> -d --privileged -e  --init odavid/jenkins-jnlp-slave -url <domain>
<token> <agent_name>

docker run --init --privileged --env-file ./.env