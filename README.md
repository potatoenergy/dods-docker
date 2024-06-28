**Day of Defeat: Source Server Docker Image**
===========================================

Run a Day of Defeat: Source server easily inside a Docker container, optimized for ARM64 (using box86).

**Supported tags**
-----------------

* `latest` - the most recent production-ready image, based on `sonroyaalmerol/steamcmd-arm64:root`

**Documentation**
----------------

### Ports
The container uses the following ports:
* `:27015 TCP/UDP` as the game transmission, pings and RCON port
* `:27005 UDP` as the client port

### Environment variables

* `DODS_ARGS`: Additional arguments to pass to the server.
* `DODS_CLIENTPORT`: The client port for the server.
* `DODS_IP`: The IP address for the server.
* `DODS_LAN`: Whether the server is LAN-only or not.
* `DODS_MAP`: The map for the server.
* `DODS_MAXPLAYERS`: The maximum number of players allowed to join the server.
* `DODS_PORT`: The port for the server.
* `DODS_SOURCETVPORT`: The Source TV port for the server.
* `DODS_TICKRATE`: The tick rate for the server.

### Directory structure
The following directories and files are important for the server:

```
📦 /home/steam
|__📁dods-server // The server root (dods folder name using env)
|  |__📁dods
|  |  |__📁cfg
|  |  |  |__⚙️server.cfg
|__📃srcds_run // Script to start the server
|__📃srcds_run-arm64 // Script to start the server on ARM64
```

### Examples

This will start a simple server in a container named `dods-server`:
```sh
docker run -d --name dods-server \
  -p 27005:27005/udp \
  -p 27015:27015 \
  -p 27015:27015/udp \
  -e DODS_ARGS="" \
  -e DODS_CLIENTPORT=27005 \
  -e DODS_IP="" \
  -e DODS_LAN="0" \
  -e DODS_MAP="de_dust2" \
  -e DODS_MAXPLAYERS="12" \
  -e DODS_PORT=27015 \
  -e DODS_SOURCETVPORT="27020" \
  -e DODS_TICKRATE="" \
  -v /home/ponfertato/Docker/dods-server:/home/steam/dods-server/dods \
  ponfertato/dayofdefeat-source:latest
```

...or Docker Compose:
```sh
version: '3'

services:
  dods-server:
    container_name: dods-server
    restart: unless-stopped
    image: ponfertato/dayofdefeat-source:latest
    tty: true
    stdin_open: true
    ports:
      - "27005:27005/udp"
      - "27015:27015"
      - "27015:27015/udp"
    environment:
      - DODS_ARGS=""
      - DODS_CLIENTPORT=27005
      - DODS_IP=""
      - DODS_LAN="0"
      - DODS_MAP="de_dust2"
      - DODS_MAXPLAYERS="12"
      - DODS_PORT=27015
      - DODS_SOURCETVPORT="27020"
      - DODS_TICKRATE=""
    volumes:
      - ./dods-server:/home/steam/dods-server/dods
```

**Health Check**
----------------

This image contains a health check to continually ensure the server is online. That can be observed from the STATUS column of docker ps

```sh
CONTAINER ID        IMAGE                    COMMAND                 CREATED             STATUS                    PORTS                                                                                     NAMES
e9c073a4b262        ponfertato/dayofdefeat-source            "/home/steam/entry.sh"   21 minutes ago      Up 21 minutes (healthy)   0.0.0.0:27005->27005/udp, 0.0.0.0:27015->27015/tcp, 0.0.0.0:27015->27015/udp   distracted_cerf
```

**License**
----------

This image is under the [MIT license](LICENSE).
