FROM ubuntu:18.04 

RUN apt-get update 
RUN apt-get install -y git cmake maven ant software-properties-common openjdk-8-jdk 
RUN apt-get install -y build-essential 
RUN apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev 
RUN apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev 

RUN git clone git://github.com/opencv/opencv.git 
WORKDIR /opencv

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 
RUN export JAVA_HOME 

RUN git checkout 3.4 && mkdir build && cd build && cmake -DBUILD_SHARED_LIBS=OFF .. && make -j8 

WORKDIR / 
RUN git clone https://github.com/antoinefraboul/ESIRTPDockerSampleApp
WORKDIR /ESIRTPDockerSampleApp 

RUN mvn install:install-file \
 -Dfile=/opencv/build/bin/opencv-346.jar \ 
 -DgroupId=org.opencv \ 
 -DartifactId=opencv \ 
 -Dversion=3.4.6 \ 
 -Dpackaging=jar \ 
 -DgeneratePom=true && mvn package 

RUN update-java-alternatives -s /usr/lib/jvm/java-1.8.0-openjdk-amd64
CMD ["java", "-Djava.library.path=/opencv/build/lib/", "-jar", "/ESIRTPDockerSampleApp/target/fatjar-0.0.1-SNAPSHOT.jar"]