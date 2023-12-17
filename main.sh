#!/command/with-contenv /bin/bash

set -e

OVPN_DOWNLOAD_DIR='/root/openvpn/';

log_err() {
  >&2 echo "${@}";
  exit 1;
}

main() {
  # check for user/pass file
  if [ ! -r "${OVPN_AUTH_USER_PASS_FILE}" ]; then
    log_err "illegal OVPN_AUTH_USER_PASS_FILE [${OVPN_AUTH_USER_PASS_FILE}]";
  fi

  # setup environment
  mkdir -p "${OVPN_DOWNLOAD_DIR}"

  if [ -z "${OVPN_OVERWRITE_FILE}" ]; then # overwrite config is not specified
    # download ovpn from nordvpn recommendation
    local server_recommendation="$(wget -q -O- 'https://nordvpn.com/wp-admin/admin-ajax.php?action=servers_recommendations' | jq -r '.[0].hostname')";
    local ovpn_url="https://downloads.nordcdn.com/configs/files/ovpn_udp/servers/${server_recommendation}.udp.ovpn";
    local ovpn_file="${OVPN_DOWNLOAD_DIR}/${server_recommendation}.udp.ovpn";
    wget -q -O "${ovpn_file}" "${ovpn_url}";
  else # use an overwrite config
    local ovpn_file="${OVPN_OVERWRITE_FILE}";
  fi

  # construct openvpn args
  local ovpn_args=( "--config" "${ovpn_file}" "--script-security" "2" "--up" "/etc/openvpn/up.sh" "--down" "/etc/openvpn/down.sh" "--auth-user-pass" "${OVPN_AUTH_USER_PASS_FILE}" );
  if [ ! -z "${OVPN_MORE_CONFIG_FILE}" ]; then
    ovpn_args+=( "--config" "${OVPN_MORE_CONFIG_FILE}" );
  fi

  # start openvpn
  exec /usr/sbin/openvpn "${ovpn_args[@]}";

  log_err "unreachable after exec-ing openvpn";
}

main;

