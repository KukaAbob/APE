# First build phase
FROM ubuntu:22.04 AS build

# Install OpenJDK and necessary tools
RUN apt-get update && apt-get install -y openjdk-17-jdk dos2unix

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Convert gradlew script to Unix format
RUN dos2unix gradlew

# Give execute permission to the gradlew script
RUN chmod +x gradlew

# Run the Gradle build with verbose logging and additional error checks
RUN ./gradlew clean build --no-daemon -x check -x test --stacktrace --info

# List files in the build/libs directory to verify JAR creation
RUN ls -l /app/build/libs/

# Final phase: Create a minimal image for running the application
FROM openjdk:17

# Set working directory
WORKDIR /app

# Copy the built JAR file from the build phase
COPY --from=build /app/build/libs/*.jar /app/app.jar

# Expose port 8080 for the application
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "/app/app.jar"]
