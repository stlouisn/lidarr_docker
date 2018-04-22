[travis_logo]: https://travis-ci.org/stlouisn/lidarr_docker.svg?branch=master
[travis_url]: https://travis-ci.org/stlouisn/lidarr_docker
[docker_stars_logo]: https://img.shields.io/docker/stars/stlouisn/lidarr.svg
[docker_pulls_logo]: https://img.shields.io/docker/pulls/stlouisn/lidarr.svg
[docker_hub_url]: https://hub.docker.com/r/stlouisn/lidarr
[microbadger_url]: https://microbadger.com/images/stlouisn/lidarr
[feathub_data]: http://feathub.com/stlouisn/lidarr_docker?format=svg
[feathub_url]: http://feathub.com/stlouisn/lidarr_docker
[issues_url]: https://github.com/stlouisn/lidarr_docker/issues
[slack_url]: https://stlouisn.slack.com/messages/CAAUWAYM9

## Lidarr Docker

[![Build Status][travis_logo]][travis_url]
[![Docker Stars][docker_stars_logo]][docker_hub_url]
[![Docker Pulls][docker_pulls_logo]][docker_hub_url]

Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.

### Tags

[![Version](https://images.microbadger.com/badges/version/stlouisn/lidarr.svg)][microbadger_url]
[![Layers](https://images.microbadger.com/badges/image/stlouisn/lidarr.svg)][microbadger_url]

### Usage

```
cd /docker/lidarr
curl --silent --show-error --output docker-compose.yml https://raw.githubusercontent.com/stlouisn/lidarr_docker/master/docker-compose.yml
docker-compose up --detach --build --remove-orphans
```

### Feature Requests

[![Feature Requests][feathub_data]][feathub_url]

### Support

[![Slack Channel](https://img.shields.io/badge/-message-no.svg?colorA=a7a7a7&colorB=3eb991&logo=slack)][slack_url]
[![GitHub Issues](https://img.shields.io/badge/-issues-no.svg?colorA=a7a7a7&colorB=e01563&logo=github)][issues_url]

### Links

##### *http://lidarr.audio/*
##### *https://github.com/lidarr/lidarr*
