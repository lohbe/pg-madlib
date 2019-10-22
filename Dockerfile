FROM postgres:10

# Install wget to get the madlib packages
# Install m4, python, and plpython for madlib
# Install all other supported external-pl langs (python3, tcl, perl)
RUN set -ex; \
        apt-get update && apt-get install -y --no-install-recommends \
                wget \
                m4 \
                python \
                postgresql-plpython-10 \
                postgresql-plpython3-10 \
                postgresql-pltcl-10 \
                postgresql-plperl-10

# Get & install madlib binaries
RUN set -ex \
        && wget --no-check-certificate -O /tmp/madlib-1.16-bin.deb https://dist.apache.org/repos/dist/release/madlib/1.16/apache-madlib-1.16-bin-Linux.deb \
        && dpkg -i /tmp/madlib-1.16-bin.deb \
        && apt-get install -f -y