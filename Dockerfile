FROM postgres:10

# Install wget to get the madlib packages
# Install m4, python, and plpython for madlib
# Install all other supported external-pl langs (python3, tcl, perl)
# Install pip
RUN set -ex; \
        apt-get update && apt-get install -y --no-install-recommends \
                wget \
                m4 \
                python python3 \
                python-pip python3-pip \
                python-setuptools python3-setuptools \
                python2.7-dev python3-dev \
                postgresql-plpython-10 \
                postgresql-plpython3-10 \
                postgresql-pltcl-10 \
                postgresql-plperl-10 \
                gcc mono-mcs \
                g++ \
                gdal-bin libgdal-dev

# Pavan (15 Dec 2019): Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

RUN set -ex; \
        pip install --upgrade pip setuptools wheel virtualenv

RUN set -ex; \
        pip3 install --upgrade pip setuptools wheel virtualenv

# Install Python libraries for data science via pip
ADD requirements.pip /tmp/
ADD requirements.pip3 /tmp/

RUN set -ex; \
        pip install -r /tmp/requirements.pip

RUN set -ex; \
        pip3 install -r /tmp/requirements.pip3

# Get & install madlib binaries
RUN set -ex \
        && wget --no-check-certificate -O /tmp/madlib-1.16-bin.deb https://dist.apache.org/repos/dist/release/madlib/1.16/apache-madlib-1.16-bin-Linux.deb \
        && dpkg -i /tmp/madlib-1.16-bin.deb \
        && apt-get install -f -y

# PostGIS binaries installation
RUN set -ex \
        && apt-get update && apt-get install -y --no-install-recommends \
                postgis \
                postgresql-10-postgis-2.5 \
                postgresql-10-postgis-2.5-scripts

# PL/R binaries installation; includes r-base-core
# build-essential required for R package installs
RUN set -ex \
        && apt-get update && apt-get install -y --no-install-recommends \
                postgresql-10-plr \
                build-essential

# Get and build additional R source packages from CRAN
# Note - this is a very slow, expensive step, only install required packages as necessary
#ADD rpackages.list /tmp/

#RUN set -ex; \
#        Rscript -e 'install.packages(as.character(read.csv("/tmp/rpackages.list")[,1]), repos="https://cran.asia")'
