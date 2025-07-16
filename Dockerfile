# Stage 1: Build plugin
FROM maven:3.9.5-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .

# Disable license plugin execution
RUN mvn clean install -DskipTests -Pdisable-license-plugin

# Stage 2: (Optional)
FROM eclipse-temurin:17-jdk
WORKDIR /plugin
COPY --from=builder /app/target/*.hpi ./
