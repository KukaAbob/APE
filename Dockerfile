# Используем образ с Java 17 и Gradle
FROM gradle:8.10.1-jdk17 as builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем dos2unix, чтобы преобразовать файлы в Unix-формат
RUN apt-get update && apt-get install -y dos2unix

# Копируем все файлы проекта в рабочую директорию
COPY . /app

# Преобразуем gradlew скрипт в Unix формат
RUN dos2unix gradlew

# Даем права на выполнение gradlew
RUN chmod +x gradlew

# Запускаем Gradle сборку
RUN ./gradlew clean build --no-daemon --stacktrace --info

# Финальный образ для запуска приложения
FROM openjdk:17-jdk-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный jar-файл
COPY --from=builder /app/build/libs/*.jar app.jar

# Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
