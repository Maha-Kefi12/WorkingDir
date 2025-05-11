# Stage 1: Build the JAR using Maven
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime image
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the JAR
COPY --from=build /build/target/GestionUser-0.0.1-SNAPSHOT.jar /app/GestionUser.jar

# Copy wait-for.sh
COPY wait-for.sh /app/wait-for.sh
RUN chmod +x /app/wait-for.sh

# Expose the port
EXPOSE 8081

# Wait for MySQL before running the app
CMD ["/app/wait-for.sh", "mysql-container", "java", "-jar", "GestionUser.jar"]
