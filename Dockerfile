# Шаг 1: Используем образ Gradle с JDK
FROM gradle:8.10.1-jdk17 AS builder

# Шаг 2: Устанавливаем рабочую директорию
WORKDIR /app

# Шаг 3: Копируем файлы сборки и зависимостей
COPY build.gradle settings.gradle ./
COPY src ./src

# Шаг 4: Выполняем сборку приложения
RUN gradle clean build --no-daemon --info

# Шаг 5: Используем минимальный образ JDK для запуска приложения
FROM eclipse-temurin:17-jdk-jammy

# Шаг 6: Устанавливаем рабочую директорию
WORKDIR /app

# Шаг 7: Копируем собранный JAR-файл из предыдущего этапа
COPY --from=builder /app/build/libs/*.jar app.jar

# Шаг 8: Открываем порт для приложения
EXPOSE 8080

# Шаг 9: Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
