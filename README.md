# hardware/selfoss

![selfoss](https://i.imgur.com/8hJyBgk.png "selfoss")

The new multipurpose rss reader, live stream, mashup, aggregation web application.

### Requirement

- Docker 1.0 or higher

### How to use

```
docker run -d \
  --name selfoss \
  -v /mnt/docker/selfoss:/selfoss/data \
  hardware/selfoss
```

### Build-time variables

- **VERSION** = selfoss version

### Environment variables

- **GID** = selfoss user id (*optional*, default: 991)
- **UID** = selfoss group id (*optional*, default: 991)

### Docker-compose

#### Docker-compose.yml

```
selfoss:
  image: hardware/selfoss
  container_name: selfoss
  volumes:
    - /mnt/docker/selfoss:/selfoss/data
```

#### Run !

```
docker-compose up -d
```

### Reverse proxy

https://github.com/Wonderfall/dockerfiles/tree/master/reverse