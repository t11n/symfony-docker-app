# symfony-docker-skeleton
Skeleton for dockerized symfony applications. Use this repository as a template for your new Symfony app. 

## Features
- Ready to use docker and docker-compose setup with nginx and php 8 fpm, suited for symfony 5 projects
- Stages for development and production environments
- Ready to go development inside developer container
- Based on symfony skeleton
- Sources mounted via NFS for rapid development with macOS
- Includes XDebug with preconfigured debugger in development stage
- composer, symfony-app as well as phpunit preinstalled
- Travis CI integrated


## How to dig into containers
Simplest way to start nginx and php-fpm containers, after preparing `docker-compose.override.yml`:

```console
jdoe@host:/home/jdoe/projects/myapp $ docker-compose up [-d|--detach]
```

Run cron-jobs or any other command by starting a new container:
```console
jdoe@host:/home/jdoe/projects/myapp $ docker-compose run [--rm] app php --version
Creating myapp_app_run ... done
PHP 8.0.2 (cli) (built: Feb  9 2021 19:20:59) ( NTS )
Copyright (c) The PHP Group
Zend Engine v4.0.2, Copyright (c) Zend Technologies
    with Zend OPcache v8.0.2, Copyright (c), by Zend Technologies
    with Xdebug v3.0.3, Copyright (c) 2002-2021, by Derick Rethans
```

Hook into a running container to execute your php software inside its environment:
```console
jdoe@host:/home/jdoe/projects/myapp $ docker-compose exec app bash -l
root@app:/var/www/app# php --version
PHP 8.0.2 (cli) (built: Feb  9 2021 19:20:59) ( NTS )
Copyright (c) The PHP Group
Zend Engine v4.0.2, Copyright (c) Zend Technologies
    with Zend OPcache v8.0.2, Copyright (c), by Zend Technologies
    with Xdebug v3.0.3, Copyright (c) 2002-2021, by Derick Rethans
```

The same for a fresh container instance:
```console
jdoe@host:/home/jdoe/projects/myapp $ docker-compose run --rm app bash -l
root@app:/var/www/app# php --version
PHP 8.0.2 (cli) (built: Feb  9 2021 19:20:59) ( NTS )
Copyright (c) The PHP Group
Zend Engine v4.0.2, Copyright (c) Zend Technologies
    with Zend OPcache v8.0.2, Copyright (c), by Zend Technologies
    with Xdebug v3.0.3, Copyright (c) 2002-2021, by Derick Rethans
```

## development and production stages

The app docker image has two stages for development and production. Development and production go in the same environment.
XDebug and its debugger is prepared in the development stage.

### docker-compose.yml & docker-compose.override.yml

The basic docker-compose.yml is intended to be extended by overrides and is therefore very minimal (no port  mappings e.g.). Extend it by adding your customized override file.

Templates are provided for development and production. The development override mounts the project directory from the host machine via nfs to enable rapid  development inside the container on macOS hosts.

## composer (php)
The latest master version of composer (https://getcomposer.org) is installed. Use it from a running container to manage your app dependencies:

```console
jdoe@host:/home/jdoe/projects/myapp $ docker-compose exec app bash -l
root@app:/var/www/app# composer --version
Composer version 2.0.11 2021-02-24 14:57:23
```

... or run it inside a fresh container, if you prefer:
```console
jdoe@host:/home/jdoe/projects/myapp $ docker-compose run --rm app bash -l
root@app:/var/www/app# composer --version
Composer version 2.0.11 2021-02-24 14:57:23
```

## symfony 5.2
The symfony 5.2 skelleton, as well as the symfony installer is part of the project. Use the skeleton or remove
it and use the `symfony` command to create a new project.
```console
jdoe@host:/home/jdoe/projects/myapp $ docker-compose run --rm app bash -l
root@app:/var/www/app# symfony new myapp
...
```

Use the symfony console from running container:
```console
jdoe@host:/home/jdoe/projects/myapp $ docker-compose exec app bash -l
root@app:/var/www/app# bin/console cache:clear
...
```
