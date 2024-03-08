# Setup VPS (Ubuntu)

### Update OS

```shell
sudo apt update && sudo apt upgrade
```

### Setup Server

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/holladevio/vps-setup/main/setup.sh)"
```

### Setup SSL

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/holladevio/vps-setup/main/setupssl)"
```
