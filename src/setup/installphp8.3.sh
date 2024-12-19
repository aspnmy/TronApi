#!/bin/bash

# 函数：检查是否安装了PHP 8.3
is_php_installed() {
    if php -v | grep -q "PHP 8.3"; then
        return 0 # PHP 8.3已安装
    else
        return 1 # PHP 8.3未安装
    fi
}

# 函数：在Debian/Ubuntu上安装PHP 8.3及其扩展
install_php_debian() {
    echo "Updating package lists..."
    sudo apt update

    echo "Installing PHP 8.3 and extensions..."
    sudo apt install -y php8.3 php8.3-cli php8.3-zip php8.3-bz2 php8.3-mysql php8.3-curl php8.3-mbstring php8.3-intl php8.3-common php8.3-gmp php8.3-composer
}

# 函数：在CentOS上安装PHP 8.3及其扩展
install_php_centos() {
    echo "Enabling Remi's repository for PHP 8.3..."
    sudo yum install -y epel-release
    sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    sudo yum module enable -y php:remi-8.3

    echo "Installing PHP 8.3 and extensions..."
    sudo yum install -y php php-cli php-zip php-bz2 php-mysqlnd php-curl php-mbstring php-intl php-gmp php-composer

    echo "Starting PHP-FPM service..."
    sudo systemctl start php-fpm
    sudo systemctl enable php-fpm
}

# 检测操作系统版本
OS_NAME="$(lsb_release -si 2>/dev/null || grep -ihs "bian" /etc/*release 2>/dev/null || echo "Unknown OS")"
OS_VERSION="$(lsb_release -sr 2>/dev/null || echo "Unknown Version")"

echo "Detected OS: $OS_NAME version $OS_VERSION"

# 检查是否安装了PHP 8.3
if is_php_installed; then
    echo "PHP 8.3 is already installed."
else
    echo "PHP 8.3 is not installed, starting installation..."

    # 根据操作系统版本安装PHP 8.3
    if [[ "$OS_NAME" == "Ubuntu" ]] || [[ "$OS_NAME" == "Debian" ]]; then
        install_php_debian
    elif [[ "$OS_NAME" == "CentOS" ]]; then
        install_php_centos
    else
        echo "This script only supports Debian/Ubuntu and CentOS."
        exit 1
    fi

    echo "PHP 8.3 installation complete."
fi