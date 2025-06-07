cmake_minimum_required(VERSION 3.9)

# Включение Hunter
include("cmake/HunterGate.cmake")
HunterGate(
    URL "https://github.com/cpp-pm/hunter/archive/v0.23.251.tar.gz"
    SHA1 "5659b15dc0884d4b03dbd95710e6a1fa0fc3258d"
)

project(print VERSION 1.0.0 LANGUAGES CXX)

# Настройки компилятора
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Конфигурация Hunter ДО добавления пакета
#hunter_config(GTest VERSION 1.11.0)  # Простая конфигурация без CMAKE_ARGS

# Добавление пакета
hunter_add_package(GTest)
find_package(GTest REQUIRED CONFIG)

# Исходные файлы
file(GLOB PRINT_SOURCES "src/*.cpp")
file(GLOB PRINT_HEADERS "include/*.h")

# Основная библиотека
add_library(print STATIC ${PRINT_SOURCES})
target_include_directories(print PUBLIC include)

# Демо-программа
add_executable(demo demo/main.cpp)
target_link_libraries(demo print)

# Тесты
add_executable(test_print test/test_print.cpp)
target_link_libraries(test_print print GTest::GTest GTest::Main)

enable_testing()
add_test(NAME PrintTest COMMAND test_print)

install(TARGETS print ARCHIVE DESTINATION lib)
install(TARGETS demo RUNTIME DESTINATION bin)
