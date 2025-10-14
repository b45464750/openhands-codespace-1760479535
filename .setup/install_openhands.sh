#!/bin/bash
# ������ ��������� OpenHands CLI

set -e

echo "=== ��������� OpenHands CLI ==="

# ��������� Docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# ��������� Docker
if ! command -v docker &> /dev/null; then
    echo "Docker �� ���������� ������� �������"
    exit 1
fi

echo "Docker �������"

# ������� ������ ������ ��������� OpenHands
if curl -fsSL https://cli.openhands.com/install.sh | sh; then
    echo "OpenHands ���������� ����� ����������� ������"
elif pip3 install openhands-ai --user; then
    echo "OpenHands ���������� ����� pip"
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "�������� Docker-���������� � OpenHands..."
    
    # ������� Dockerfile
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
    
    # �������� �����
    if docker build -t openhands-codespace -f Dockerfile.openhands .; then
        echo "Docker-����� � OpenHands ������"
        echo "��� ������� OpenHands �����������:"
        echo "docker run -it --rm -v $(pwd):/workspace -w /workspace openhands-codespace bash"
    else
        echo "������ �������� Docker-������"
        exit 1
    fi
fi

# ��������� ���������
if command -v openhands &> /dev/null; then
    echo "OpenHands CLI ������� ����������"
    openhands --version
else
    echo "OpenHands CLI �� ���������� � �������, �� �������� � Docker-����������"
fi

echo "=== ��������� ��������� ==="
