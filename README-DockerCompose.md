
## .env example
```
export SLACK_SIGNING_SECRET=6d<snip>
export SLACK_BOT_TOKEN=xoxb-53<snip>
export ADMIN_DATABASE_USER=postgres
export DATABASE_USER=postgres
export ADMIN_DATABASE_PASSWORD=postgres
export DATABASE_PASSWORD=postgres
export ADMIN_DATABASE_SCHEMA=f3
export DATABASE_SCHEMA=f3

```


## Docker Info

Docker client
https://docs.docker.com/engine/install/

Docker Compose
https://docs.docker.com/compose/install/

## Docker Compose help

### Cleaning up docker images, volumes etc is critical to success.

Stop all running containers
```
docker stop $(docker ps -aq)
```

Remove all containers
```
docker rm -f $(docker ps -aq)
```

Prune unused docker volumes
```
docker system prune --volumes --all
```

Remove all volumes
```
docker volume rm $(docker volume ls)
```

Full Cleanup
```
docker stop $(docker ps -aq) && \
docker rm -f $(docker ps -aq) && \
docker system prune --volumes --all -f &&
docker volume rm -f $(docker volume ls)
```

### building containers

```
docker-compose build
```

### run the app and db together 

```
docker-compose up
```

Full Rebuild and Start
```
docker-compose up --build
```

### Investigate on a container ( example )
```
 docker ps -a
CONTAINER ID   IMAGE                     COMMAND                  CREATED          STATUS          PORTS                                                   NAMES
b9d0e9fddcf6   f3-nation-slack-bot-app   "nodemon --exec 'poe…"   40 seconds ago   Up 38 seconds   0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp, 8080/tcp   f3-nation-slack-bot-app-1
d5564b04bf76   postgres:16               "docker-entrypoint.s…"   40 seconds ago   Up 39 seconds   0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp             f3-nation-slack-bot-db-1
0c8b1f336739   adminer                   "entrypoint.sh docke…"   40 seconds ago   Up 39 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp             f3-nation-slack-bot-adminer-1

whayutin@fedora:~/git/F3/f3-nation-slack-bot$ docker exec -ti b9d0e9fddcf6 /bin/bash

root@b9d0e9fddcf6:/app# which python
/usr/local/bin/python
root@b9d0e9fddcf6:/app# python --version
Python 3.12.11
root@b9d0e9fddcf6:/app# root@013a555a8290:/app# ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 21:50 ?        00:00:00 node /usr/bin/nodemon --exec python main.py -e py
root          19       1  0 21:50 ?        00:00:00 sh -c python main.py
root          20      19 17 21:50 ?        00:00:03 python main.py
root          42       0  0 21:50 pts/0    00:00:00 /bin/bash
root          48      42  0 21:50 pts/0    00:00:00 ps -ef

```

