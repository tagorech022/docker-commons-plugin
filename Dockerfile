# Stage 1: Build Jenkins plugin
FROM maven:3.9.5-eclipse-temurin-17 AS builder

WORKDIR /app

COPY . .

# Activate profile that disables problematic plugins
RUN mvn clean install -DskipTests -Pskip-license-plugin

# Stage 2 (optional): Copy only the HPI if needed
FROM eclipse-temurin:17-jdk

WORKDIR /plugin

COPY --from=builder /app/target/*.hpi ./plugin.hpi

CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
