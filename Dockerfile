# Stage 1: Use Maven with Amazon Corretto 17 for build
FROM maven:3.9.6-amazoncorretto-17 as builder

# Set working directory
WORKDIR /plugin

# Copy source code
COPY . .

# Skip tests and license plugin to avoid Java 17 module error
RUN mvn clean install -DskipTests -Dlicense.skip=true


# Stage 2: (Optional) Just output the built .hpi plugin artifact
# If you want to run Jenkins with this plugin, you can extend a Jenkins image instead
FROM amazoncorretto:17 as output

WORKDIR /output

# Copy .hpi or .jar plugin from the build stage
COPY --from=builder /plugin/target/*.hpi .

# Default command just lists the output
CMD ["ls", "-l", "/output"]
