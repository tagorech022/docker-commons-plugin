# Stage 1: Build the plugin
FROM maven:3.9.6-amazoncorretto-17 as builder

WORKDIR /plugin
COPY . .

# Skip broken license plugin
RUN mvn clean install -DskipTests -Dlicense.skip=true
