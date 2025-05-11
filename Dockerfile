# Stage 1: Build the JAR using Maven
FROM maven:3.9.4-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /build

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /build/target/GestionUser-0.0.1-SNAPSHOT.jar /app/GestionUser.jar

# Expose the port used in application.properties
EXPOSE 8081

# Set environment variables to override properties if needed (optional)
# You can pass these in docker-compose too
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql-container:3306/DatabaseEssai?useUnicode=true&useJDBCCompliantTimezoneShift=true&createDatabaseIfNotExist=true&useLegacyDatetimeCode=false&serverTimezone=UTC

# Run the application
CMD ["java", "-jar", "GestionUser.jar"]

