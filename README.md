# OpenHands CLI в GitHub Codespace

Добро пожаловать в автоматически настроенный Codespace для использования OpenHands CLI!

## Что уже установлено:

- Python 3.11
- Node.js
- Docker (с возможностью Docker-in-Docker)
- Все зависимости для OpenHands CLI

## Автоматическая установка OpenHands CLI:

При создании этого Codespace была запущена автоматическая установка OpenHands CLI, которая:

1. Запустила Docker
2. Попыталась установить OpenHands CLI через официальный установочный скрипт
3. Если официальный скрипт не сработал, попыталась установить через pip
4. Если оба метода не сработали, создала Docker-контейнер с OpenHands

## Проверка установки:

Чтобы проверить, что OpenHands CLI установлен, выполните в терминале:

```bash
openhands --version
```

или

```bash
which openhands
```

## Использование:

После подтверждения установки вы можете использовать OpenHands CLI для создания приложений. Например:

```bash
# Пример команды для создания калькулятора
openhands --task "Create a calculator application with GUI that includes basic operations (addition, subtraction, multiplication, division) as well as square root (√) and power (x^y) functions" --model Grok --api-key $GROK_API_KEY
```

## Настройка API-ключей:

Установите ваши API-ключи в переменные окружения:

```bash
export GROK_API_KEY=ваш_ключ_здесь
export DEEPSEEK_API_KEY=ваш_ключ_здесь
```

## Возможные проблемы:

1. Если OpenHands CLI не установился автоматически, вы можете запустить установку вручную:
   ```bash
   bash ./.setup/install_openhands.sh
   ```

2. Если возникли проблемы с Docker, проверьте статус службы:
   ```bash
   sudo systemctl status docker
   ```

## Структура проекта:

- `.devcontainer/devcontainer.json` - конфигурация Codespace
- `.setup/install_openhands.sh` - скрипт автоматической установки OpenHands
- `.github/workflows/setup-openhands.yml` - GitHub Action для установки (был удален из-за ограничений токена)

Этот Codespace полностью готов к использованию OpenHands CLI для автоматического создания приложений!