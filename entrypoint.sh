#!/bin/sh -l

set -euo pipefail

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi

cd "${GITHUB_WORKSPACE}/"

echo "Starting Build\n"

hugo version

echo "hugo ${1}"

hugo $1

echo "Build Ended \n"



#mkdir "${HOME}/.ssh"
#echo "${VPS_DEPLOY_KEY}" > "${HOME}/.ssh/id_rsa"
#chmod 600 "${HOME}/.ssh/id_rsa"

rsync --version

echo "Deploying with Rsync"

rsync -ratlz --rsh="/usr/bin/sshpass -p ${RSYNC_PASSWORD} ssh -o StrictHostKeyChecking=no -l hugo" ${GITHUB_WORKSPACE}/public/  ${VPS_DEPLOY_USER}@${VPS_DEPLOY_HOST}:${VPS_DEPLOY_DEST}


#sh -c "
#rsync $2 \
#  ${GITHUB_WORKSPACE}/public \
#  ${VPS_DEPLOY_USER}@${VPS_DEPLOY_HOST}:${VPS_DEPLOY_DEST}
#"

exit 0
