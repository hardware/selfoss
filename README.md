# hardware/selfoss

![selfoss](https://i.imgur.com/8hJyBgk.png "selfoss")

The new multipurpose rss reader, live stream, mashup, aggregation web application.

### Requirement

- Docker 1.0 or higher
- MySQL

### How to use

```
docker run -d \
  --name selfoss
  -p 80:80 \
  -e DBHOST=mysql \
  -e DBUSER=selfoss \
  -e DBNAME=selfoss \
  -e DBPASS=xxxxxxx \
  -e SALT=xxxxxxx \
  hardware/selfoss
```

### Environment variables

- **GID** = selfoss user id (*optional*, default: 991)
- **UID** = selfoss group id (*optional*, default: 991)
- **DBHOST** = MySQL instance ip/hostname (*optional*, default: mariadb)
- **DBUSER** = MYSQL database username (*optional*, default: selfoss)
- **DBNAME** = MYSQL database name (*optional*, default: selfoss)
- **DBPASS** = MYSQL database (**required**)
- **SALT** = Selfoss cookie salt (**required**)

### Docker-compose

#### Docker-compose.yml

```
selfoss:
  image: hardware/selfoss
  container_name: selfoss
  links:
    - mariadb:mariadb
  ports:
    - "80:80"
  environment:
    - DBHOST=mariadb
    - DBUSER=selfoss
    - DBNAME=selfoss
    - DBPASS=xxxxxxx
    - SALT=xxxxxxx

mariadb:
  image: mariadb:10.1
  volumes:
    - /docker/mysql/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=xxxx
    - MYSQL_DATABASE=selfoss
    - MYSQL_USER=selfoss
    - MYSQL_PASSWORD=xxxx
```

#### Run !

```
docker-compose up -d
```