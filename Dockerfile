# Шаг 1: Используем образ Gradle с JDK
FROM gradle:8.10.1-jdk17 AS builder

# Шаг 2: Устанавливаем рабочую директорию
WORKDIR /app

# Шаг 3: Копируем файлы сборки и зависимостей
COPY build.gradle settings.gradle ./
COPY src ./src

# Убедитесь, что файл .env существует в контексте сборки
COPY .env ./

# Шаг 4: Выполняем сборку приложения, пропуская тесты
RUN gradle clean build --no-daemon --info -x test

# Шаг 5: Используем минимальный образ JDK для запуска приложения
FROM eclipse-temurin:17-jdk-jammy

# Шаг 6: Устанавливаем рабочую директорию
WORKDIR /app

# Шаг 7: Копируем собранный JAR-файл из предыдущего этапа
COPY --from=builder /app/build/libs/*.jar app.jar

# Шаг 8: Копируем файл .env в финальный образ
COPY --from=builder /app/.env ./

# Шаг 9: Открываем порт для приложения
EXPOSE 8080

# Шаг 10: Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
