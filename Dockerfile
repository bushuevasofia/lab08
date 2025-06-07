# Многоэтапная сборка для уменьшения размера образа
FROM ubuntu:22.04 AS builder

# 1. Установка зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    cmake \
    make \
    && rm -rf /var/lib/apt/lists/*

# 2. Копирование только необходимых файлов
COPY CMakeLists.txt /app/
COPY include/ /app/include/
COPY src/ /app/src/
COPY demo/ /app/demo/

WORKDIR /app

# 3. Сборка проекта
RUN mkdir -p _build && \
    cd _build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/app/_install && \
    cmake --build . --target install -- -j$(nproc)

# Финальный образ
FROM ubuntu:22.04

# 1. Runtime зависимости
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# 2. Настройка логирования
RUN mkdir -p /home/logs
ENV LOG_PATH=/home/logs/log.txt
VOLUME /home/logs

# 3. Копирование собранных файлов
COPY --from=builder /app/_install/bin/demo /usr/local/bin/demo

# 4. Точка входа
WORKDIR /home
ENTRYPOINT ["demo"]
