# Setup VPS (Ubuntu)

### Update OS

```shell
sudo apt update && sudo apt upgrade
```

### Setup Server

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/holladevio/vps-setup/main/setup.sh)"
```

### Add User And SSH

```shell
sh -c "$(https://raw.githubusercontent.com/holladevio/vps-setup/main/adduser)"
```

### Setup SSL

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/holladevio/vps-setup/main/setupssl)"
```

### Setup For Docker

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/holladevio/vps-setup/main/setup-for-docker)"
```
