PROTON_UNIT="wg-quick-proton.service"

personal_up() {
  systemctl is-active --quiet "$PROTON_UNIT"
}

company_up() {
  pritunl-client list -j 2>/dev/null |
    jq -e 'any(.[]; ((.status // .state // "") | ascii_downcase) as $s | $s != "" and $s != "disconnected")' >/dev/null 2>&1
}

state() {
  if personal_up; then
    echo personal
  elif company_up; then
    echo company
  else
    echo off
  fi
}

stop_pritunl() {
  local id
  for id in $(pritunl-client list -j | jq -r '.[].id'); do
    pritunl-client stop "$id" >/dev/null 2>&1 || true
  done
}

start_personal() {
  stop_pritunl
  systemctl start "$PROTON_UNIT"
  echo "Personal VPN (Proton) up."
}

start_company() {
  systemctl stop "$PROTON_UNIT" 2>/dev/null || true

  local list count id
  list=$(pritunl-client list -j)
  count=$(jq 'length' <<<"$list")

  if [ "$count" -eq 0 ]; then
    echo "No Pritunl profiles found. Add one with:" >&2
    echo "  pritunl-client add <profile-uri>" >&2
    return 1
  elif [ "$count" -eq 1 ]; then
    id=$(jq -r '.[0].id' <<<"$list")
  elif [ -t 0 ]; then
    id=$(jq -r '.[] | "\(.id)\t\(.name)"' <<<"$list" |
      gum choose --header "Company profile:" | cut -f1)
  else
    id=$(jq -r '.[0].id' <<<"$list")
  fi

  [ -n "$id" ] || return 1
  pritunl-client start "$id"
  echo "Company VPN (Pritunl) connecting: $id"
}

vpn_off() {
  systemctl stop "$PROTON_UNIT" 2>/dev/null || true
  stop_pritunl
  echo "All VPNs off."
}

status() {
  if personal_up; then
    echo "personal : UP    $(wg show proton 2>/dev/null | awk '/endpoint/{print $2}')"
  else
    echo "personal : down"
  fi
  echo "company  :"
  pritunl-client list
}

cmd="${1:-}"
if [ -z "$cmd" ]; then
  cmd=$(gum choose personal company off status)
fi

case "$cmd" in
personal | on) start_personal ;;
company) start_company ;;
off) vpn_off ;;
status | st) status ;;
state) state ;;
*)
  echo "usage: vpn {personal|company|off|status|state}" >&2
  exit 1
  ;;
esac
