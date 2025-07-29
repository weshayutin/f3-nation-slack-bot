# F3 Nation Slack Bot - Docker Development Setup

This setup includes automatic database schema creation using the F3-Data-Models repository.

## Quick Start

1. **Create your `.env` file** with your Slack credentials:
   ```bash
   cp .env.example .env  # if available
   # Edit .env with your values
   ```
   
   ```bash
   # Database Configuration  
   export DATABASE_USER=postgres
   export DATABASE_PASSWORD=postgres
   export DATABASE_SCHEMA=f3_schema
   export POSTGRES_PASSWORD=$DATABASE_PASSWORD
   export DATABASE_SCHEMA=f3_schema
   export POSTGRES_DB=f3_db

   # Slack Configuration
   export SLACK_BOT_TOKEN=xoxb-your-bot-token
   export SLACK_SIGNING_SECRET=your-signing-secret
   ```
   

2. **Start the development environment**:
   ```bash
   docker-compose up --build
   ```

That's it! The F3-Data-Models repository is automatically cloned and set up during the Docker build process.

## What Happens

1. **Database Service** (`db`): PostgreSQL 16 starts up
2. **Database Initialization** (`db-init`): 
   - Built from `./db-init/Dockerfile`
   - Automatically clones the F3-Data-Models repository
   - Waits for database to be ready (5-second intervals)
   - Creates the database if it doesn't exist
   - Installs Poetry dependencies for migrations
   - Runs Alembic migrations to create all tables
   - Sets up the complete F3 database schema
3. **App Service** (`app`): 
   - Starts the F3 Nation Slack Bot
   - Connects to the initialized database
   - Runs with hot-reloading for development

## Services

- **App**: http://localhost:3000
- **Database**: localhost:5432 (postgres/postgres)
- **Adminer**: http://localhost:8080 (admin WEBUI for the db)

## Environment Variables

The following environment variables are set automatically for Docker via the compose.yml:

- `LOCAL_DEVELOPMENT=true` - Enables development mode
- `DATABASE_HOST=db` - Points to the Docker database service
- `PYTHON_VERSION=3.12` - Python version for database initialization

You need to create a `.env` file with your database and Slack credentials:

```bash
# Database Configuration  
export DATABASE_USER=postgres
export DATABASE_PASSWORD=postgres
export DATABASE_SCHEMA=f3_schema
export POSTGRES_PASSWORD=$DATABASE_PASSWORD
export DATABASE_SCHEMA=f3_schema
export POSTGRES_DB=f3_db

# Slack Configuration
export SLACK_BOT_TOKEN=xoxb-your-bot-token
export SLACK_SIGNING_SECRET=your-signing-secret

# ... other required variables
```

## Troubleshooting

- **docker-compose logs** can be very noisy.  You can isolate the app logs w/ `docker-compose logs -f app` or `docker-compose logs -f db` say in two different terminals
- **Database schema issues**: The `db-init` service should handle all schema creation automatically
- **Build issues**: The F3-Data-Models repository is cloned during Docker build
- **Database connection**: The `db-init` service waits for PostgreSQL to be ready (5-second intervals) before running migrations
- **Environment variables**: Make sure your `.env` file contains `DATABASE_USER`, `DATABASE_PASSWORD`, and `DATABASE_SCHEMA`
- **Poetry issues**: Dependencies are installed automatically during database initialization

## Manual Database Reset

If you need to reset the database or destroy the containers:

```bash
docker-compose down -v  # Removes volumes
docker-compose up --build  # Recreates everything
``` 

## Additional Troubleshooting

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

Full Cleanup - essentially the same as `docker-compose down -v `
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
