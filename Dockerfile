FROM adoptopenjdk/openjdk8:debian AS builder

WORKDIR /app
RUN apt-get update \
  && apt-get install -y --no-install-recommends maven=3.6.0-1~18.04.1
RUN apt-get install -y apt-utils

COPY pom.xml .
RUN mvn -N io.takari:maven:wrapper -Dmaven=3.5.6

COPY . /app
RUN ./mvnw clean install

ARG bx_dev_user=root
ARG bx_dev_userid=1000
RUN export BX_DEV_USER=$bx_dev_user
RUN export BX_DEV_USERID=$bx_dev_userid
RUN if [ $bx_dev_user != "root" ]; then useradd -ms /bin/bash -u $bx_dev_userid $bx_dev_user; fi

FROM adoptopenjdk/openjdk8:ubi-jre

# Copy over app from builder image into the runtime image.
RUN mkdir /opt/app
COPY --from=builder /target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar /opt/app/app.jar

ENV PORT 8080

EXPOSE 8080

ENTRYPOINT [ "sh", "-c", "java -jar /opt/app/app.jar" ]
