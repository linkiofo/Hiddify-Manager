source ../common/utils.sh
if ! is_installed nginx; then
    useradd nginx
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor |
        sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" |
        sudo tee /etc/apt/sources.list.d/nginx.list
    sudo apt update -y

    install_package nginx
fi

systemctl kill nginx >/dev/null 2>&1
systemctl disable nginx >/dev/null 2>&1
systemctl kill apache2 >/dev/null 2>&1
systemctl disable apache2 >/dev/null 2>&1
# pkill -9 nginx

rm /etc/nginx/conf.d/web.conf
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/conf.d/default.conf
rm /etc/nginx/conf.d/xray-base.conf
rm /etc/nginx/conf.d/speedtest.conf

mkdir run
ln -sf $(pwd)/hiddify-nginx.service /etc/systemd/system/hiddify-nginx.service
systemctl enable hiddify-nginx.service
