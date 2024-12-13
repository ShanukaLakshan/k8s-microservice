# Use the official Maven image with Eclipse Temurin JDK 21 for building the application
FROM maven:3.9.4-eclipse-temurin-21 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files and the pom.xml first for better caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Now copy the source files
COPY src ./src

# Package the application (skip tests to speed up build)
RUN mvn clean package -DskipTests

# Use a smaller, official OpenJDK image for the runtime
FROM eclipse-temurin:21-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port that your app runs on (default for Spring Boot)
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]
