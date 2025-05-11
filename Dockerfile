# Stage 2: Create the runtime image
FROM openjdk:17-jdk-slim

# Install netcat (nc)
RUN apt-get update && apt-get install -y netcat

# Set working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /build/target/GestionUser-0.0.1-SNAPSHOT.jar /app/GestionUser.jar

# Expose the port
EXPOSE 8080

# Add the wait-for script
COPY wait-for.sh /app/wait-for.sh
RUN chmod +x /app/wait-for.sh

# Run the wait-for script and then the Spring Boot application
CMD ["./wait-for.sh", "mysql-container:3306", "--", "java", "-jar", "GestionUser.jar"]
