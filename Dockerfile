# Используем базовый образ Gradle для сборки проекта
FROM gradle:8.10.1-jdk17 AS builder

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем все файлы проекта в контейнер
COPY . /app

# Устанавливаем dos2unix, чтобы преобразовать gradlew в Unix-формат
RUN apt-get update && apt-get install -y dos2unix

# Преобразуем gradlew в Unix-формат и даем права на выполнение
RUN dos2unix gradlew
RUN chmod +x gradlew

# Выполняем сборку проекта с использованием Gradle
RUN ./gradlew build

# Создаем новый образ для запуска приложения
FROM eclipse-temurin:17-jdk-jammy

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный jar-файл из предыдущего шага сборки
COPY --from=builder /app/build/libs/*.jar app.jar

# Открываем порт, если это необходимо
EXPOSE 8080

# Запускаем jar-файл
ENTRYPOINT ["java", "-jar", "app.jar"]
