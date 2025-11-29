<!-- to create a container it is simply -->
docker run --name  --env(for environment variables in this case password) --publish hostport:containerport application
docker run --name mypostgresdb --env POSTGRES_PASSWORD=passsy --publish 5432:5432 postgres:15-alpine

<!-- docker hub(including nginx) -->
your one stop shop for docker images

<!-- volumes are created to persist data -->
for example lets say we have a database and we want to persist data from our database so that when the container goes down we dont lose our data we create a volume
<!-- to mount a volume to a container the command is  -->
<!-- NB: source refers to the location in the host machine while destination refers to the location in the container -->
docker run -it --mount source=volumename,destination=/where your data in the container will be located<space> containername/container
<!-- for example putting psql data into the hosts data file for backup would look like -->
docker run -it --rm --volume volumename -e POSTGRES_PASSWORD=password postgres:15-alpine


<!-- BIND MOUNTS -->
docker run -it --rm --mount type=bind, source=(data source from the container),destination=(destination in the host os/machine)
docker run -it --rm --mount type=bind, source="${PWD}"/mydata,destination=(destination in host machine) ubuntu:22.04

<!-- docker flags -->
-- interactive - this creates a shell for the image we run (allows for interactivity like giving input via terminal)
--tty - this allows for a shell terminal to be create
--rm - tells it not to persist the contain(delete when it closes)
docker ps -a  - lists all the containers i currently have 
docker start dockername - this start the container but you wont see it so you have to attach it
docker attach dockername - this attaches to the shell running in that container
docker volume create volumename - this creates a docker volume
docker rm -f containername - this is to remove a container
docker context ls - this is to check the current contexts which docker has and seeing which one is running
docker context use (context)- this is to switch the docker context


<!-- building docker builds from file -->
<!-- start -->
example1

docker buildx build -t kawakawa -<<EOF
FROM ubuntu:22.04
RUN apt update && apt install -y iputils-ping
EOF

