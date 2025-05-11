# Use a base image that has Java (assuming Java backend)
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy your application’s JAR file into the container
COPY target/backend.jar /app/GestionUser.jar

# Expose the port your backend runs on
EXPOSE 8080

# Command to run the backend application
CMD ["java", "-jar", "GestionUser.jar"]
