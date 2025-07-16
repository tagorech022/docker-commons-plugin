# Stage 1: Build the Jenkins plugin
FROM maven:3.9.6-eclipse-temurin-17 as builder

WORKDIR /app

# Copy plugin source code
COPY . .

# Clean install the plugin, skipping tests (license plugin already removed from pom.xml)
RUN mvn clean install -DskipTests

# Stage 2: Optional clean runtime image with only the plugin artifact
FROM eclipse-temurin:17-jdk as runtime

WORKDIR /app

# Copy only the final HPI plugin from the builder stage
COPY --from=builder /app/target/*.hpi ./plugin.hpi

CMD ["echo", "Plugin build complete. HPI ready."]
