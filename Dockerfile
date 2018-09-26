FROM ubuntu:16.04
LABEL maintainer="Steve tsang <mylagimail2004@yahoo.com>"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    locales \
    git \
    build-essential \
    python3-dev \
    python3-pip \
    pigz \
    make \
    
## for diamond g++/gcc
    ninja-build \
    cmake \
    zlib1g-dev \
    aptitude \
    libstdc++6 \
    software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && \
    apt-get install gcc-snapshot -y && \
    apt-get update && \
    apt-get install gcc-6 g++-6 -y && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5 && \
##
    apt-get install -y libdatetime-perl libxml-simple-perl libdigest-md5-perl default-jre bioperl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

### Cutadapt
WORKDIR /opt
#RUN pip3 install cutadapt==1.2.1 ## 1.2.1 not available?
RUN pip3 install cutadapt

### Sickle
WORKDIR /opt
RUN git clone https://github.com/najoshi/sickle.git
WORKDIR /opt/sickle
RUN make
RUN cp sickle /usr/local/bin

### PrinSEQ-lite
WORKDIR /opt
RUN wget https://sourceforge.net/projects/prinseq/files/standalone/prinseq-lite-0.20.4.tar.gz/download
RUN tar xvzf download
RUN rm download
RUN cp prinseq-lite-0.20.4/*.pl /usr/local/bin

### Diamond
## install gcc g++ cmake zlib-dev ninja libstdc++ zlib
WORKDIR /opt
RUN git clone https://github.com/bbuchfink/diamond.git
WORKDIR /opt/diamond
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_BUILD_MARCH=x86-64 .
RUN ninja && ninja install
## cp diamond /usr/local/bin

### Proka
WORKDIR /opt
#RUN apt-get install -y libdatetime-perl libxml-simple-perl libdigest-md5-perl default-jre bioperl
RUN cpan Bio::Perl
RUN git clone https://github.com/tseemann/prokka.git
#$HOME/prokka/bin/prokka --setupdb
RUN cp /opt/prokka/bin/prokka /usr/local/bin

### SRA toolkit
WORKDIR /opt
RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar xvzf sratoolkit.current-ubuntu64.tar.gz
WORKDIR /opt/sratoolkit.2.9.2-ubuntu64
ENV PATH "$PATH: /opt/sratoolkit.2.9.2-ubuntu64/bin/"

### Meme - version released on 6/18/2017, predicted based on publication date
WORKDIR /opt
RUN apt-get update
RUN apt-get install -y libxml2 libxslt1-dev ghostscript libgs-dev imagemagick autoconf automake libtool

#RUN wget http://meme-suite.org/meme-software/5.0.2/meme-5.0.2.tar.gz
#RUN tar xvzf meme-5.0.2.tar.gz
#WORKDIR /opt/meme-5.0.2
#RUN ./configure --prefix=/opt/meme --with-url=http://meme-suite.org/ --enable-build-libxml2 --enable-build-libxslt
#RUN make
#RUN make test
#RUN make install

WORKDIR /opt
RUN wget http://meme-suite.org/meme-software/4.12.0/meme_4.12.0.tar.gz
RUN tar xvzf meme_4.12.0.tar.gz
WORKDIR meme_4.12.0
RUN ./configure --prefix=/opt/meme --with-url=http://meme-suite.org/ --enable-build-libxml2 --enable-build-libxslt
RUN make
#RUN make test
RUN make install
RUN cp /opt/meme/bin/* /usr/local/bin/

### megacc 
WORKDIR /opt
RUN mkdir -p /opt/mega
COPY megacc-7.0.26-1.x86_64.tar.gz /opt/mega
WORKDIR /opt/mega
RUN tar xvzf megacc-7.0.26-1.x86_64.tar.gz
RUN cp /opt/mega/mega* /usr/local/bin

### bowtie2 - use binary from 2018/01
WORKDIR /opt
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4/bowtie2-2.3.4-linux-x86_64.zip
RUN unzip bowtie2-2.3.4-linux-x86_64.zip
RUN cp /opt/bowtie2-2.3.4-linux-x86_64/bowtie* /usr/local/bin

### SPAdes 3.9.0
WORKDIR /opt
RUN wget https://github.com/ablab/spades/releases/download/v3.9.0/SPAdes-3.9.0-Linux.tar.gz
RUN tar xvzf SPAdes-3.9.0-Linux.tar.gz
RUN cp /opt/SPAdes-3.9.0-Linux/bin/* /usr/local/bin


COPY Dockerfile /opt/.

