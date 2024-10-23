# Используем образ с Java 17 и Gradle
FROM gradle:8.10.1-jdk17 as builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем все файлы проекта в рабочую директорию
COPY . /app

# Устанавливаем нужные утилиты
RUN apt-get update && apt-get install -y dos2unix

# Преобразуем gradlew скрипт в Unix формат
RUN dos2unix gradlew

# Даем права на выполнение gradlew
RUN chmod +x gradlew

# Удаляем предыдущие сборки, если они есть
RUN rm -rf /app/build/

# Дополнительно выводим структуру папки для отладки
RUN ls -la /app

# Запускаем Gradle сборку с очисткой кэша и сборкой проекта
# Очищаем кэш и выводим информацию об ошибках
RUN ./gradlew clean --no-daemon --stacktrace --info || { cat /app/build/reports/tests/test/index.html; exit 1; }

# Финальный образ для запуска приложения
FROM openjdk:17-jdk-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный jar-файл
COPY --from=builder /app/build/libs/*.jar app.jar

# Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
