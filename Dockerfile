#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
WORKDIR /home/app
COPY src ./src
COPY pom.xml ./pom.xml
RUN mvn -N io.takari:maven:wrapper
RUN ./mvnw clean install

#
# Package stage
#
FROM openjdk:11-jre-slim
COPY --from=build /home/app/target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar /usr/local/lib/demo.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]
