# First build phase
FROM amazoncorretto:17 AS build

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install dos2unix to handle line ending conversions
RUN yum install -y dos2unix

# Convert gradlew script to Unix format
RUN dos2unix gradlew

# Give execute permission to the gradlew script
RUN chmod +x gradlew

# Build the project using Gradle wrapper with verbose logging
RUN ./gradlew clean build -x check -x test --stacktrace --info

# List files in the build/libs directory to verify JAR creation
RUN ls -l /app/build/libs/

# Final phase: Create a minimal image for running the application
FROM amazoncorretto:17

# Set working directory
WORKDIR /app

# Copy the built JAR file from the build phase
COPY --from=build /app/build/libs/*.jar /app/app.jar

# Expose port 8080 for the application
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "/app/app.jar"]
