# Start from GridGain Professional image.
FROM gridgain/gridgain-pro:2.7.2

# Set config uri for node.
ENV CONFIG_URI Cluster1-server.xml

# Copy optional libs.
ENV OPTION_LIBS ignite-rest-http

# Update packages and install maven.
RUN set -x \
    && apk add --no-cache \
        openjdk8

RUN apk --update add \
    maven \
    && rm -rfv /var/cache/apk/*

# Append project to container.
ADD . Cluster1

# Build project in container.
RUN mvn -f Cluster1/pom.xml clean package -DskipTests

# Copy project jars to node classpath.
RUN mkdir $IGNITE_HOME/libs/Cluster1 && \
   find Cluster1/target -name "*.jar" -type f -exec cp {} $IGNITE_HOME/libs/Cluster1 \;