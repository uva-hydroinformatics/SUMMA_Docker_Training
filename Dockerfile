FROM ubuntu:xenial

# change working directory
WORKDIR /code
COPY . /code

# add necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    ca-certificates \
    git \
    make \
    libnetcdff-dev \
    liblapack-dev \ 
    wget && \
    apt-get clean

# install gfortran-6
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends gfortran-6 && \
    apt-get clean

# install miniconda3
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

# install pysumma and summa
RUN git clone https://github.com/UW-Hydro/pysumma.git && \
    cd pysumma && \
    conda env create -f environment.yml && \
    conda clean -afy
    
# install notebook
RUN conda install notebook && \
    conda clean -afy

# following run commands run in conda environment
SHELL ["conda", "run", "-n", "pysumma", "/bin/bash", "-c"]

# install pysumma and summa
RUN pip install git+https://github.com/UW-Hydro/pysumma.git@master
RUN pip install geoviews
RUN git clone https://github.com/NCAR/summa.git
    
# set environment variables for SUMMA compilation
ENV F_MASTER="/code/summa"
ENV FC="gfortran"
ENV FC_EXE="/usr/bin/gfortran-6"
ENV INCLUDES='-I/usr/include'
ENV LIBRARIES='-L/usr/lib -lnetcdff -lblas -llapack'
RUN make -f ${F_MASTER}/build/Makefile

# creates mount points from the host to container so docker daemon is accessible inside
VOLUME /var/run/docker.sock
VOLUME /usr/bin/docker

# add conda env to jupyter kernel
RUN python -m ipykernel install --user --name pysumma

EXPOSE 8888
