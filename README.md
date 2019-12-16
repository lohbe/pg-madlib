# Postgres - MADlib - PL/x - PostGIS

A dockerised Postgresql 10 'official' image with MADlib 1.16 and the official PL languages - pgSQL, Python, Perl, TCL as well as PostGIS.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You will need:

* A working Docker or container environment (e.g. Docker CLI and docker-machine)
* Internet access

### Building the container

To build the docker image,
```
# docker build -t pg-madlib-image .
```

If disk space error occurs during build, please prune any unused containers via:

```
# docker system prune -a
```

### First time Run

Refer to the Postgresql [docker hub](https://hub.docker.com/_/postgres) for base image customisations & start options.

```
docker run --name pg-madlib -e POSTGRES_PASSWORD=mypassword -p 5432:5432 -d pg-madlib-image
```

### Enabling MADlib
To work with MADlib functions, you need to first run `madpack install` on your database.

Get into the running container,
```
docker exec -it pg-madlib /bin/bash
```

Change to admin user `postgres` and run the install script. Assumes the defaults [here](https://cwiki.apache.org/confluence/display/MADLIB/Installation+Guide#InstallationGuide-Envvariables).
```
su - postgres
/usr/local/madlib/bin/madpack -v -s madlib -p postgres install
```

If you have created a custom admin user and/or database, install with the `-c` option.
```
/usr/local/madlib/bin/madpack -v -s madlib -p postgres -c $POSTGRES_USER/$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB install
```

`$POSTGRES_USER` and `$POSTGRES_PASSWORD` provides the admin credentials to madlib.
`$POSTGRES_DB` specifies the database to install MADlib into.

### Enabling PL/languages

You can do this via `psql`

```
su - postgres
psql
```

Create the extension as follows:
```
CREATE EXTENSION plperlu;
```
Replace `plperlu` with any of the following when required:

* plpythonu
* pltcl
* plr

### Enabling PostGIS Adminpack

First get a bash prompt in a running container, then follow the instructions [here](https://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS24UbuntuPGSQL10Apt#EnableAdminpack).

### Additional libraries & packages for PL/Python

Use & extend the included `requirements.pip` (Python 2) and/or `requirements.pip3` (Python 3) to include additional Python packages during the docker image build.

A quick and easy way to export the current package list and get started is to use `pip/pip3 freeze` e.g.:

```
# pip3 freeze | tee requirements.pip3
numpy==1.17.4
pandas==0.25.3
python-dateutil==2.8.1
pytz==2019.3
six==1.13.0
```

To verify that the library is available in PL/Python via `psql`:
```
postgres=# do $$
import pandas
plpy.notice(pandas.__version__)
$$ language plpython3u;
NOTICE:  0.25.3
DO
```

### Additional libraries & packages for PL/R

_NOTE - adding libraries to R is a time-consuming process, as the source packages are downloaded and built from [CRAN](https://cran.asia). Consider loading only the necessary packages._

Use & extend the included `rpackages.list` to include additional R packages during the docker image build.

A quick and easy way to export the current package list from `R` and get started is to use: 
```
> write.csv(unique(data.frame(installed.packages())[,1]),"rpackages.list",row.names=F)
```

On the Linux CLI, it is possible to use `Rscript`:
```
# Rscript -e 'write.csv(unique(data.frame(installed.packages())[,1]),"rpackages.list",row.names=F)'
```

The resulting package list looks as follows:
```
# cat rpackages.list
"x"
"assertthat"
"BH"
"crayon"
"magrittr"
"pkgconfig"
"plogr"
"R6"
"zeallot"
"base"
...
..
```

Some warning messages are displayed if the `install.package()` command encounters packages that have already been installed.

To verify that the library is available in PL/R via `psql`:
```
postgres=# do $$
library(dplyr)
pg.thrownotice(packageVersion("dplyr"))
$$ language plr;
NOTICE:  0.8.3
DO
```

### Stopping & removing container

```
docker stop pg-madlib
docker rm pg-madlib
```

## Running the tests

### Check MADlib installation

To check if MADlib is installed correctly, run
```
su - postgres
/usr/local/madlib/bin/madpack -v -s madlib -p postgres -c $POSTGRES_USER/$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB install-check
```

### Check PL languages

TO verify that the necessary languages have been installed, run in `psql`:
```
SELECT * from pg_language;
```

There are also several pl*.sql scripts in this repository that you can test the actual functions with.

### Persistence step-by-step guide (From: Pavan 15 Dec 2019)

Please refer to parent documentation in '[Where to Store Data](https://hub.docker.com/_/postgres)' for more details & options.

The data created by/stored in postgresql or any process in container is persistent as long as the container of the image is not removed, its available between stop and start of container.

If we want the data persistent across containers even after removal of containers of the image then we have to use volume groups and map the volume mount on the host to folder `/var/lib/postgresql/data` on the container while creating the container by the run command.

First, run on the Docker host: `# docker volume create firstvol`
This will create a folder /var/lib/docker/volumes/firstvol/_data on the host machine.

Then while creating container for the image with the following command we have to use `-v` option where we map volume mount on host machine to postgresql data folder in container. This way data is persistent across the containers of the image even after removal of the container.
```
docker run --name pg-madlib -v firstvol:/var/lib/postgresql/data -e POSTGRES_PASSWORD=mypassword -p 5432:5432 -d pg-madlib-image
```

## Deployment

To save a copy of the resulting image as a tar archive, use [`docker save`](https://docs.docker.com/engine/reference/commandline/save/). This image has yet to be tested in Production environments - use at your own risk.

## Tested With

* [docker-machine](https://docs.docker.com/machine/)
* [pgcli](https://www.pgcli.com/)
* [vagrant](https://www.vagrantup.com/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
