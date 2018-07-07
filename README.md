# hardware/selfoss

![selfoss](https://i.imgur.com/8hJyBgk.png "selfoss")

### What is this ?

The new multipurpose rss reader, live stream, mashup, aggregation web application.

### Features

- Lightweight & secure image (no root process)
- Based on Alpine Linux
- Latest Selfoss version (2.18)
- SQLite driver
- With Nginx and PHP7

### Build-time variables

- **VERSION** = selfoss version
- **SHA256_HASH** = SHA256 hash of selfoss archive

### Ports

- 8888

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **UID** | selfoss user id | *optional* | 991
| **GID** | selfoss group id | *optional* | 991
| **CRON_PERIOD** | Cronjob period for updating feeds | *optional* | 15m
| **UPLOAD_MAX_SIZE** | Attachment size limit | *optional* | 25M
| **LOG_TO_STDOUT** | Enable nginx and php error logs to stdout | *optional* | false
| **MEMORY_LIMIT** | PHP memory limit | *optional* | 128M

### Docker-compose.yml

```yml
selfoss:
  image: hardware/selfoss
  container_name: selfoss
  volumes:
    - /mnt/docker/selfoss:/selfoss/data
```
