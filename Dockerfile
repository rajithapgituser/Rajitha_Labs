### Build ###
FROM maven:3.5-jdk-8 AS build  
COPY src /usr/src/app/src  
COPY pom.xml /usr/src/app  
RUN mvn -f /usr/src/app/pom.xml clean package

### Run ###
FROM gcr.io/distroless/java  
COPY --from=build /usr/src/app/target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar /usr/app/app.jar  
EXPOSE 8080  
ENTRYPOINT ["java","-jar","/usr/app/app.jar"]
