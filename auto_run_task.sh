#!/bin/bash
# Скрипт автоматического запуска задач в Codespace

# Этот скрипт добавляет автоматический запуск задач при старте Codespace
# Скрипт будет выполняться каждый раз при запуске Codespace если добавить его в devcontainer.json

echo "=== Запуск автоматизации задач для OpenHands CLI ==="

# Установим переменные окружения
export GROK_API_KEY="gsk_tPBQAmaHWAQ7V3gSD2wMWGdyb3FYe7AeoGsvhpO6DyOQQloAptvyGROK"
export DEEPSEEK_API_KEY="sk-97455d6734d54c10ba47ab52780fe91cDeepSeek2"

# Проверим, установлен ли OpenHands CLI
if ! command -v openhands &> /dev/null; then
    echo "OpenHands CLI не установлен, запускаем установку"
    bash ./.setup/install_openhands.sh
fi

# Подождем немного для завершения установки
sleep 10

# Проверим снова
if command -v openhands &> /dev/null; then
    echo "OpenHands CLI установлен, проверяем наличие задач..."

    # Проверим, существует ли файл с задачей
    if [ -f "task_config.json" ]; then
        echo "Найден файл задачи, запускаем задачу..."

        # Извлекаем параметры из JSON файла
        TASK=$(jq -r '.task' task_config.json)
        MODEL=$(jq -r '.model' task_config.json)
        API_KEY=$(jq -r '.api_key' task_config.json)

        echo "Выполняем задачу: ${TASK:0:50}..."

        # Запускаем задачу OpenHands
        openhands --task "$TASK" --model "$MODEL" --api-key "$API_KEY"
    else
        echo "Файл задачи не найден. Репозиторий готов к использованию."
        echo "Чтобы запустить задачу, создайте файл task_config.json с нужной задачей."
    fi
else
    echo "OpenHands CLI не установлен"
fi

echo "=== Завершено автоматическое выполнение задач ==="