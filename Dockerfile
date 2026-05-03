FROM eclipse-temurin:21-jre-alpine-3.22
WORKDIR /root
COPY target/dunoesanchaeg-0.0.1-SNAPSHOT.jar app.jar
ARG BUILD_PROFILE=local
ARG BUILD_PORT=8080
ENV TZ=Asia/Seoul
ENV APP_PROFILE=${BUILD_PROFILE}
EXPOSE ${BUILD_PORT}
CMD ["java", "-jar", "app.jar", "--spring.profiles.active=${APP_PROFILE}"]