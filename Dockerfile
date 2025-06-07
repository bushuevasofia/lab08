FROM ubuntu:18.04

RUN apt update && apt install -yy gcc g++ cmake git

COPY . /print

WORKDIR /print

# Создаем чистую сборку
RUN rm -rf _build _install && mkdir -p _build

# Сборка
WORKDIR /print/_build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/print/_install
RUN cmake --build . --target install

# Убеждаемся, что бинарник демо есть
RUN ls -la /print/_install/bin

# Переменная окружения для логов
ENV LOG_PATH /home/logs/log.txt
VOLUME /home/logs

WORKDIR /print/_install/bin

ENTRYPOINT ["./demo"]
