FROM ubuntu:latest
ENV PATH="/SAClientUtil/bin:${PATH}"
ENV SERVICE_URL="https://staging.appscan.internal"
RUN apt update
RUN apt install -y curl unzip maven openjdk-11-jre gradle && apt clean
RUN curl -fsSLk $SERVICE_URL/api/v4/Tools/SAClientUtil?os=linux > SAClientUtil.zip
RUN unzip SAClientUtil.zip
RUN rm -f SAClientUtil.zip
RUN mv SAClientUtil.* SAClientUtil
