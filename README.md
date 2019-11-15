# Postgres - MADlib - PL/x - PostGIS

A dockerised Postgresql 10 'official' image with MADlib 1.16 and the official PL languages - pgSQL, Python, Perl, TCL as well as PostGIS.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You will need:

* A working Docker or container environment (e.g. Docker CLI and docker-machine)

### Building the container

To build the docker image,
```
docker build -t pg-madlib-image .
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
SELECT * from pg_languages;
```

There are also several pl*.sql scripts in this repository that you can test the actual functions with.

## Deployment

To save a copy of the resulting image as a tar archive, use [`docker save`](https://docs.docker.com/engine/reference/commandline/save/). This image has yet to be tested in Production environments - use at your own risk.

## Tested With

* [docker-machine](https://docs.docker.com/machine/)
* [pgcli](https://www.pgcli.com/)
* [vagrant](https://www.vagrantup.com/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
