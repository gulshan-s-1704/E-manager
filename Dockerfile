# ---------- Stage 1: Build the WAR with Maven ----------
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# ---------- Stage 2: Run on Tomcat ----------
FROM tomcat:9.0-jdk17-temurin
# Remove default Tomcat sample apps
RUN rm -rf /usr/local/tomcat/webapps/*
# Deploy our WAR as ROOT so the app is served at "/" instead of "/ecommerce-platform"
COPY --from=build /app/target/ecommerce-platform.war /usr/local/tomcat/webapps/ROOT.war

# Render injects a $PORT env var and expects the app to listen on it.
# This script rewrites Tomcat's connector port at container startup.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
