# Шаг 1: Используем образ Gradle для сборки
FROM gradle:8.10.1-jdk17 AS builder

# Шаг 2: Устанавливаем рабочую директорию
WORKDIR /app

# Шаг 3: Копируем исходный код проекта
COPY . .

# Шаг 4: Устанавливаем dos2unix и преобразуем файл gradlew (если он нужен)
RUN apt-get update && apt-get install -y dos2unix
RUN dos2unix gradlew && chmod +x gradlew

# Шаг 5: Обновляем зависимости и выполняем сборку
RUN ./gradlew clean build --no-daemon --info || (cat build/reports/compileJava/debug.log && exit 1)

# Шаг 6: Новый этап: создание минимального образа для запуска
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Шаг 7: Копируем собранный JAR-файл
COPY --from=builder /app/build/libs/*.jar app.jar

# Шаг 8: Открываем порт 8080
EXPOSE 8080

# Шаг 9: Запуск JAR-файла
ENTRYPOINT ["java", "-jar", "app.jar"]
