#!/bin/bash
#set -x

command -v docker || curl http://get.docker.com/ | sh

cyan="$(tput setaf 6)"
green="$(tput setaf 2)"
bgreen="$(tput bold ; tput setaf 2)"
red="$(tput setaf 1)"
bred="$(tput bold ; tput setaf 1)"
reset="$(tput sgr0)"

cnf='haproxy.cfg.d'
[[ ! -d "$cnf" ]] && cnf="/tmp/$cnf"

RP_NAME=reverseproxy.local

echo ${1%:*}

for args in $@
do
  case ${1%:*} in
    'clear'|'clean')
      echo -e "\n${cyan}==> Killing and removing running container${reset}"
      docker rm $(docker kill $RP_NAME)
      [ "${1#*:}" = "all" ] && \
      echo -e "\n${cyan}==> Removing untagged/dangled images${reset}" && \
      docker rmi $(docker images -qf dangling=true)
      ;;
    'build')
      # using cache or not
      nocache=
      [ "${1#*:}" = "nocache" ] && nocache="--no-cache"

      # building kibana
      echo -e "\n${cyan}==> Building haproxy image${reset}"
      docker build $nocache -t ekino/haproxy:base haproxy
      ;;
    'run')
      mkdir -p "$cnf"
      docker run --name $RP_NAME -v "$(readlink -f "$cnf")":/opt/haproxy.cfg.d -d -p 443:443 ekino/haproxy:base
      w=5 ; echo -e "\n${cyan}==> Waiting ${w}s for reverse-proxy container${reset}" ; sleep $w
      docker logs $(docker ps -lq)

      # The end
      cat <<EOF
  ${green}
  Load your configuration :
  ${cyan}
    - now copy your 'haproxy.cfg' file to $cnf
    - check you backend servers statuses : docker exec -ti $RP_NAME /showstat.sh
  ${reset}
EOF
      ;;
  esac
  shift
done 3>&1 1>&2 2>&3 | awk '{print "'$red'" $0 "'$reset'"}'
