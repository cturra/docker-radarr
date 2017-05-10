About this container
---
This container runs the A fork of [Sonarr](https://sonarr.tv) to work with movies à la Couchpotato. More about Radarr can be found at:

  https://radarr.video


Running from Docker Hub
---
Pull and run -- it's this simple.

```
# pull from docker hub
$> docker pull cturra/radarr

# run radarr
$> docker run --name=radarr                                           \
              --restart=always                                        \
              --detach=true                                           \
              --volume=/etc/localtime:/etc/localtime:ro               \
              --volume=/path/to/config/dir:/volumes/config/radarr     \
              --volume=/path/to/media/dir:/volumes/media              \
              --volume=/path/to/download/dir:/data/downloads/complete \
              --publish=7878:7878                                     \
              cturra/radarr
```


Building and Running with Docker Compose
---
Using the `docker-compose.yml` file included in this git repo, you can build
the container yourself (should you choose to).

```
# buid radarr
$> docker-compose build radarr

# run radarr
$> docker-compose up -d radarr

# (optional) check the logs
$> docker-compose logs radarr
```


Building and Running with Docker engine
---
Using the `vars` file in this git repo, you can update any of the variables to
reflect your environment. Once updated, simply execute the `build` then `run` scripts.

```
# build radarr
$> ./build.sh

# run radarr
$> ./run.sh
```
