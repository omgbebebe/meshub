# Overview

This is a MVP of a tool to collect, process and propagate an [Meshtastic](https://meshtastic.org/) [MQTT](https://mqtt.org/) messages across various brokers such as a [meshmap](https://meshmap.net/), [meshtastic.liamcottle.net](https://meshtastic.liamcottle.net/), [onemesh](https://map.onemesh.ru/) and so on.

![traffic flow](/docs/traffic_flow_overview.png)

TBC;

# Deployment

TBD;

# Dev shell

This project uses the [Nix](https://nixos.org/guides/how-nix-works/) to build all dependencies and [devenv](https://devenv.sh/) to manage a development environments.
Another useful tool is [direnv](https://direnv.net/). To enter to the dev environment just `cd` to the project directory and enbale it with `direnv allow`. After that you can

```shell
devenv up # to fire up all services
```
![devenv processes image](/docs/devenv_processes.png)

# Help and discussion

If you have any question or suggestion please use an issue tracker of this project.

Russian-language chat is also available at [Zulip channel](https://sarmesh.zulipchat.com/#narrow/channel/537804-meshub)
