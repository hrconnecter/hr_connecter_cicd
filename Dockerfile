# Use OpenJDK as the base image
FROM openjdk:11-jdk

# Set environment variables for SonarQube
ENV SONARQUBE_VERSION=9.9.0.59531
ENV SONARQUBE_HOME=/opt/sonarqube
ENV PATH="$SONARQUBE_HOME/bin:$PATH"

# Install necessary packages
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and install SonarQube
RUN mkdir -p $SONARQUBE_HOME && \
    curl -L "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONARQUBE_VERSION.zip" -o sonarqube.zip && \
    if [ $? -ne 0 ]; then echo "Download failed"; exit 1; fi && \
    unzip sonarqube.zip -d $SONARQUBE_HOME && \
    rm sonarqube.zip && \
    mv $SONARQUBE_HOME/sonarqube-$SONARQUBE_VERSION/* $SONARQUBE_HOME && \
    rmdir $SONARQUBE_HOME/sonarqube-$SONARQUBE_VERSION

# Expose the default SonarQube port
EXPOSE 9000

# Start SonarQube
CMD ["sh", "-c", "$SONARQUBE_HOME/bin/linux-x86-64/sonar.sh start"]
