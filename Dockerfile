FROM ubuntu:22.04

# Устанавливаем зависимости одной командой 
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Копируем файлы проекта
COPY . /print
WORKDIR /print

# Сборка проекта (исправленные команды)
RUN mkdir -p _build && \
    cd _build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../_install && \
    cmake --build . --target install

# Настройка логирования
RUN mkdir -p /home/logs
ENV LOG_PATH /home/logs/log.txt
VOLUME /home/logs

# Точка входа
WORKDIR /print/_install/bin
ENTRYPOINT ["./demo"]
