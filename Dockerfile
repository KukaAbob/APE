# Шаг 1: Используем образ Gradle для сборки
FROM gradle:8.10.1-jdk17 AS builder

# Шаг 2: Устанавливаем рабочую директорию
WORKDIR /app

# Шаг 3: Копируем исходный код проекта
COPY . /app

# Шаг 4: Устанавливаем dos2unix и преобразуем файл gradlew
RUN apt-get update && apt-get install -y dos2unix
RUN dos2unix gradlew && chmod +x gradlew

# Шаг 5: Обновляем зависимости
RUN ./gradlew --refresh-dependencies

# Шаг 6: Сборка с подробным выводом ошибок
RUN ./gradlew clean build --no-daemon --stacktrace

# Шаг 7: Новый этап: создание минимального образа для запуска
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Шаг 8: Копируем собранный JAR-файл
COPY --from=builder /app/build/libs/*.jar app.jar

# Шаг 9: Открываем порт 8080
EXPOSE 8080

# Шаг 10: Запуск JAR-файла
ENTRYPOINT ["java", "-jar", "app.jar"]
