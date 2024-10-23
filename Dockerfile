# Use a base image with Java 17 and Gradle pre-installed
FROM gradle:8.10.1-jdk17 as builder

# Set the working directory
WORKDIR /app

# Copy project files to the working directory
COPY . /app

# Install necessary tools
RUN apt-get update && apt-get install -y dos2unix

# Convert gradlew script to Unix format
RUN dos2unix gradlew

# Give execute permission to the gradlew script
RUN chmod +x gradlew

# Clean the build directory if it exists
RUN rm -rf /app/build/

# List files in the images directory to identify problematic files (for debugging)
RUN ls -l /app/build/resources/main/images/

# If necessary, remove the problematic file (adjust as needed)
RUN rm -f /app/build/resources/main/images/??.png

# Run the Gradle build with verbose logging and additional error checks
RUN ./gradlew clean build --no-daemon -x check -x test --stacktrace --info

# Final stage to create the runnable image
FROM openjdk:17-jdk-slim

# Set the working directory for the final image
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Specify the command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
