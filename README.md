# OpenVPN-client

This is a docker image of an OpenVPN client tied to a SOCKS proxy server. It is useful to isolate network changes (so the host is not affected by the modified routing). 

+ Supports directory style (where the certificates are not bundled together in one `.ovpn` file)
+ An `update-resolv-conf` equivalence would be executed on container startup

## Usage

### :latest

```bash
docker run \
           --device=/dev/net/tun \
           --cap-add=NET_ADMIN \
           -v <your_openvpn_directory>:/root/openvpn/:ro \
           -p 1080:1080 \
           melsonlai/docker-openvpn-client-socks:latest
```

`<your_openvpn_directory>` should contain 1 and only 1 `*.ovpn`. This `ovpn` file would be used as the connection profile.  
Connect to SOCKS5 proxy through `localhost:1080`.  

### :nordvpn

The `:nordvpn` image queries for server recommendation from NordVPN and automatically downloads the OpenVPN UDP config for connection. 

```bash
docker run \
           --device=/dev/net/tun \
           --cap-add=NET_ADMIN \
           -e OVPN_AUTH_USER_PASS_FILE=<your_auth_user_pass_file> \ # Required
           -e OVPN_MORE_CONFIG_FILE=<your_extra_ovpn_config_file> \ # Optional. An extra config file to be passed to openvpn
           -e OVPN_OVERWRITE_FILE=<your_ovpn_overwrite_file> \ # Optional. Disable the recommendation behavior and use the specified config for openvpn. Useful when NordVPN API can't be accessed
           -v <your_auth_user_pass_file> \ # Required
           -v <your_extra_ovpn_config_file> \ # Optional
           -v <your_ovpn_overwrite_file> \ # Optional
           -p 1080:1080 \
           melsonlai/docker-openvpn-client-socks:nordvpn
```

Connect to SOCKS5 proxy through `localhost:1080`.  


# Acknowledgement and Revision

+ 20201120: Add `:nordvpn`
+ 20200327: Forked from <https://github.com/kizzx2/docker-openvpn-client-socks>
+ 20200327: Restructure with <https://github.com/just-containers/s6-overlay>

