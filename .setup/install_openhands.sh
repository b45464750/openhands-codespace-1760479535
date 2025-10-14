#!/bin/bash
# Скрипт установки OpenHands CLI

set -e

echo "=== Установка OpenHands CLI ==="

# Запускаем Docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Проверяем Docker
if ! command -v docker &> /dev/null; then
    echo "Docker не установлен должным образом"
    exit 1
fi

echo "Docker запущен"

# Пробуем разные методы установки OpenHands
if curl -fsSL https://cli.openhands.com/install.sh | sh; then
    echo "OpenHands установлен через официальный скрипт"
elif pip3 install openhands-ai --user; then
    echo "OpenHands установлен через pip"
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "Создание Docker-контейнера с OpenHands..."
    
    # Создаем Dockerfile
    cat > Dockerfile.openhands << 'EOF'
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    docker.io \
    docker-compose \
    sudo \
    python3-tk \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://cli.openhands.com/install.sh | sh || \
    pip3 install openhands-ai --user

WORKDIR /workspace
VOLUME /workspace

CMD ["/bin/bash"]
EOF
    
    # Собираем образ
    if docker build -t openhands-codespace -f Dockerfile.openhands .; then
        echo "Docker-образ с OpenHands создан"
        echo "Для запуска OpenHands используйте:"
        echo "docker run -it --rm -v $(pwd):/workspace -w /workspace openhands-codespace bash"
    else
        echo "Ошибка создания Docker-образа"
        exit 1
    fi
fi

# Проверяем установку
if command -v openhands &> /dev/null; then
    echo "OpenHands CLI успешно установлен"
    openhands --version
else
    echo "OpenHands CLI не установлен в системе, но доступен в Docker-контейнере"
fi

echo "=== Установка завершена ==="
