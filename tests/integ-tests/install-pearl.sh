set -e

pip install --user pearlcli

pearl init

echo "PEARL_PACKAGES['test'] = {'url': '${PWD}'}" >> ~/.config/pearl/pearl.conf
