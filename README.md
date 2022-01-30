# Orchestrator Exercise
This is an exercise in container orchestrators. It aims just to exercise me in orchestrators and to serve as future code reference.
Started January 2022.

Content:
 * trabalhador.py: this program is meant to be run in a container; it just connects to a database and writes an "i'm alive" signal.
 * Dockerfile: to build the code from trabalhador.py into a container
 * docker-compose.yml: to launch the PostgreSQL database with non-ephemeral storage along with the trabalhador container.
 
 Useful commands:
 * test trabalhador code:
`python3 trabalhador.py` 
 * build trabalhador container:
`docker build -t trabalhador .`
 * test trabalhador code, in a container:
`docker container run --rm -it --network=host trabalhador` 
 * run a PostgreSQL database in a container with ephemeral storage:
`docker container run --name meupostgres --network host --env POSTGRES_PASSWORD=larissinha postgres`
 * create the "trabalhador" table that is required in the database for the "trabalhador" code to run:
```Sql
create table trabalhador (
log char(100),
dt timestamp
);
```
 * run a PostgreSQL client to check results:
`docker container run -it --rm --network host postgres psql -U postgres -h 127.0.0.1`
 * other stuff that might be useful: 
```
python3 -m pip install time
```


exercício:
tentar lançar um swarm local de qualquer imagem (até de uma das minhas, talvez) e então continuar a palestra. 
	mas antes, fazer:
		criar um postgres persistente (no docker-compose): ok
		criar um container "trabalhador": ok
		colocar o "trabalhador" no docker-compose: ok
		colocar tudo isso no swarm: pendente.
		
		
how to format an MD file: https://medium.com/@saumya.ranjan/how-to-write-a-readme-md-file-markdown-file-20cb7cbcd6f 

swarm commands:
see if active:
    docker info
initialyze:
    docker swarm init 
ls:
    docker node ls
start container in swarm:
    docker service ...
    docker service ls                                   lista os serviços
    docker service create alpine ping 8.8.8.8
    docker service ps <service name>                    lista onde roda cada instância dos serviços
    docker service update <id> --replicas 3


docker swarm join --token SWMTKN-1-1js4qrlu35gjoaw82rq3zme3b228teogo6zc3af19yeomnbal3-3ytpela6ul86uw4zownnkp78c 192.168.15.9:2377

docker service create --env POSTGRES_PASSWORD=larissinha --name meupostgres --network swarmexercicio1_net1 postgres

swarmexercicio1_net1