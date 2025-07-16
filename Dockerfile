# Use Maven with Java 17 — required for Jenkins plugin development
FROM maven:3.9.6-eclipse-temurin-17

# Set working directory inside the container
WORKDIR /docker-commons-plugin

# Copy all plugin source files into the container
COPY . .

# Run tests using Maven and jenkins-test-harness
CMD ["mvn", "test"]
