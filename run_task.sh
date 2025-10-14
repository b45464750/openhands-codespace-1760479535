#!/bin/bash
# Скрипт запуска задачи для OpenHands CLI
# Этот скрипт будет выполнен в Codespace

# Установим переменные окружения
export GROK_API_KEY="gsk_tPBQAmaHWAQ7V3gSD2wMWGdyb3FYe7AeoGsvhpO6DyOQQloAptvyGROK"
export DEEPSEEK_API_KEY="sk-97455d6734d54c10ba47ab52780fe91cDeepSeek2"

# Проверим, установлен ли OpenHands CLI
if ! command -v openhands &> /dev/null; then
    echo "OpenHands CLI не установлен, выполняем установочный скрипт..."
    bash ./.setup/install_openhands.sh
fi

# Подождем немного для завершения установки
sleep 5

# Проверим снова
if command -v openhands &> /dev/null; then
    echo "OpenHands CLI установлен, запускаем задачу из config..."

    # Запускаем задачу из конфигурационного файла
    if [ -f "task_config.json" ]; then
        # Извлекаем параметры из JSON файла
        TASK=$(jq -r '.task' task_config.json)
        MODEL=$(jq -r '.model' task_config.json)
        API_KEY=$(jq -r '.api_key' task_config.json)

        echo "Выполняем задачу: $TASK"
        openhands --task "$TASK" --model "$MODEL" --api-key "$API_KEY"
    else
        echo "Файл task_config.json не найден"
    fi
else
    echo "OpenHands CLI все еще не установлен"
    # Возможно, OpenHands CLI доступен только в Docker-контейнере
    if [ -f "Dockerfile.openhands" ]; then
        echo "Пытаемся запустить задачу через Docker..."
        docker run -it --rm -v $(pwd):/workspace -w /workspace openhands-codespace bash -c "
            export GROK_API_KEY=$GROK_API_KEY
            openhands --task '$TASK' --model '$MODEL' --api-key \$GROK_API_KEY
        "
    fi
fi