FROM registry.access.redhat.com/ubi8/openjdk-17:1.19-4.1715070735 AS build
ENV home=/home/app
WORKDIR ${home}
RUN mkdir -p ${home}/target/classes && chown -R 1001:0 ${home} && chmod -R 775 ${home}
COPY . ${home}/
RUN mvn package -Dmaven.test.skip=true


FROM registry.access.redhat.com/ubi8/openjdk-17:1.19-4.1715070735
WORKDIR ${home}
EXPOSE 8080
COPY --from=build /home/app/target/*.jar app.jar
#COPY  ./target/*.jar app.jar
ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-jar", "app.jar"]
