FROM gitpod/workspace-full-vnc

ENV ANDROID_HOME=/workspace/android-sdk \
    FLUTTER_ROOT=/workspace/flutter \
    FLUTTER_HOME=/workspace/flutter

USER root

RUN apt-get update && \
    apt-get -y install build-essential libkrb5-dev gcc make gradle openjdk-8-jdk && \
    apt-get clean && \
    apt-get -y autoremove

# Install Chrome.
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add 
RUN    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list 
RUN    apt-get update 
RUN    apt-get install google-chrome-stable    
