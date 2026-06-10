# Optional Jenkins agent image with Java, Maven, and Chrome for UI tests.
# Build:  docker build -t automationbdd-jenkins-agent docker/jenkins-agent
# Run:    docker run -it --rm automationbdd-jenkins-agent mvn test -s maven-settings-central.xml

FROM maven:3.9-eclipse-temurin-24

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    unzip \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

ENV CI=true
WORKDIR /workspace
