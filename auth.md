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
docker run -it --rm -v "$(pwd)/home_codex:/root/.codex" codex:latest sh
```

TODO automate
TODO make usable for multiple containers in parallel  (only copy auth.json?)
