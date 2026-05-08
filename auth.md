$ docker run -it --rm --entrypoint sh codex:latest
> codex login --device-auth

another terminal

```bash
$ docker ps
CONTAINER ID   IMAGE          COMMAND   CREATED         STATUS         PORTS     NAMES
5cc8dbfc39c1   codex:latest   "sh"      4 minutes ago   Up 4 minutes             priceless_kilby
$ mkdir home_codex
$ docker cp 5cc8dbfc39c1:/root/.codex/. home_codex/
```

the run container like

```bash
docker run -it --rm \
    -v "$(pwd)/home_codex:/home/codex/.codex" \
    -v "YOUR_CODE:/home/codex/src" \
    codex:latest
```

TODO automate
TODO make usable for multiple containers in parallel  (only copy auth.json?)
TODO support for different user-id/group-id (currently just 1000:1000)
