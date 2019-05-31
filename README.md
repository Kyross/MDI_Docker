# CR MDI TP DOCKER
*31/05/2019*

Berthet Vincent
Fraboul Antoine

## Objectif

L'objectif de ce TP est d'utiliser une image docker pour lancer un projet java utilisant OpenCV.


1. [Fonctionnement](#Fonctionnement)
2. [Execution](#Execution)
3. [Paquets installés](#Paquets-installés)

## Fonctionnement

Dans un premier temps, il nous a fallu installer certain [packages](#Paquets-installés) sur notre Ubuntu afin de pouvoir utiliser les outils de compilations, OpenCv, gérer nos dépendances, etc.

Nous avons définis que nous utiliserions Ubuntu 18.04 ([bionic - 18.04 LTS](http://releases.ubuntu.com/18.04/)), qui est la version la plus récente de cette ditribution en Long Term Support afin d'être sur une version stable.

Puis, il nous a fallu ensuite récupérer la bibliothèque OpenCV en ligne via son adresse [GitHub](https://github.com/opencv/opencv), qu'il faut compiler : 

```dockerfile=
RUN git checkout 3.4 && mkdir build && cd build && cmake DBUILD_SHARED_LIBS=OFF .. && make -j8 
```

Nous avons ensuite récupéré le code Java de l'application, qui a été corrigé sur un [dépôt personnel](https://github.com/antoinefraboul/ESIRTPDockerSampleApp) (fork du dépôt original).
On utilise ensuite Maven pour gérer les dépendances de ce projet :

```dockerfile=
RUN mvn install:install-file \
 -Dfile=/opencv/build/bin/opencv-346.jar \ 
 -DgroupId=org.opencv \ 
 -DartifactId=opencv \ 
 -Dversion=3.4.6 \ 
 -Dpackaging=jar \ 
 -DgeneratePom=true && mvn package 
```

Enfin nous pouvons lancer l'application avec Java :

```dockerfile=
CMD ["java", "-Djava.library.path=/opencv/build/lib/", "-jar", "/ESIRTPDockerSampleApp/target/fatjar-0.0.1-SNAPSHOT.jar"]
```

## Execution

Pour utiliser ce dockerfile il faut tout d'abord le compiler :

```console =
sudo docker build . --tag="mdi_trollface"
```

Après avoir compiler ce fichier nous pouvons utiliser docker pour lancer notre application : 

```console =
sudo docker run -p "8080:8080" mdi_trollface
```
![0_run.png](/images/0_run.png)

Le serveur avec l'application est donc lancé on y accède via notre navigateur : [localhost](localhost:8080)

On prend ensuite un cliché avec la caméra, si un visage est detecté une troll face s'applique sur la photo.

![1_matrollface.png](/images/1_matrollface.png)
## Paquets installés

* [Build-essential](https://packages.ubuntu.com/fr/bionic/build-essential) : Par défaut, Ubuntu n'inclut pas tous les outils nécessaires pour procéder à la compilation de logiciels et bibliothèques, on importe donc les paquets de construction essentiels 
* [Git](https://packages.ubuntu.com/disco/git) : Afin de cloner nos datas et OpenCV
* [Cmake](https://packages.ubuntu.com/fr/bionic/cmake) : Cross-platform, open-source make system
* [Maven](https://packages.ubuntu.com/fr/bionic-updates/maven) : Java software project management and comprehension tool
* [Ant](https://packages.ubuntu.com/fr/bionic-updates/ant) : Java based build tool like make
* [Software-properties-common](https://packages.ubuntu.com/fr/bionic/software-properties-common) : Manage the repositories that you install software from
* [Openjdk-8-jdk](https://packages.ubuntu.com/fr/bionic/openjdk-8-jdk) : OpenJDK Development Kit (JDK)
* [Libgtk2.0-dev](https://packages.ubuntu.com/fr/bionic/libgtk2.0-dev) : Development files for the GTK+ library
* [Pkg-config](https://packages.ubuntu.com/fr/bionic/eclipse-cdt-pkg-config) : Pkg-config support for Eclipse C/C++ development tools
* [Libavcodec-dev](https://packages.ubuntu.com/bionic/libavcodec-dev) : FFmpeg library with de/encoders for audio/video codecs 
* [Libavformat-dev](https://packages.ubuntu.com/bionic/libavformat-dev) : FFmpeg library with (de)muxers for multimedia containers
* [Libswscale-dev](https://packages.ubuntu.com/bionic/libswscale-dev) : FFmpeg library for image scaling and various conversions 
* [Python-dev](https://packages.ubuntu.com/fr/bionic/libboost-mpi-python-dev) : C++ interface to the Message Passing Interface (MPI)
* [Python-numpy](https://packages.ubuntu.com/fr/bionic/python-numpy) : Numerical Python adds a fast array facility to the Python language
* [Libtbb](https://packages.ubuntu.com/fr/bionic/libtbb-dev) : Parallelism library for C++
* [Libjpeg-dev](https://packages.ubuntu.com/fr/bionic/libjpeg-dev) : JPEG library
* [Libpng-dev](https://packages.ubuntu.com/fr/bionic/libpng-dev) : PNG library
* [Libtiff-dev](https://packages.ubuntu.com/fr/bionic/libtiff-dev) : Tag Image File Format library (TIFF)
* [Libdc1394-22-dev](https://packages.ubuntu.com/fr/bionic/libdc1394-22-dev) : High level programming interface for IEEE 1394 digital cameras