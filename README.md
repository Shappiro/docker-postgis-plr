# docker-postgis-plr

A simple docker container that runs PostGIS

Visit our page on the docker hub at: https://hub.docker.com/r/corylabiosphere/postgis-plr/

There are a number of other docker postgis containers out there. This one
differentiates itself by:

* provides ssl support out of the box
* connections are restricted to the docker subnet
* a default database 'gis' is created for you so you can use this container 'out of the
  box' when it runs with e.g. QGIS
* Ability to create multiple database when you spin the database
* Enable multiple extensions in the database when setting it up, plr included
* Enable R statistical language with GIS modules preinstalled

There is a nice 'from scratch' tutorial on using this docker image on Alex Urquhart's
blog [here](https://alexurquhart.com/post/set-up-postgis-with-docker/) - if you are
just getting started with docker, PostGIS and QGIS, we really recommend that you use it.

## Tagged versions

The following convention is used for tagging the images we build:

corylabiosphere/postgis-plr:[postgres_version]-[postgis-version]-[r-version]

So for example:

``corylabiosphere/postgis-plr:9.6-2.4-3.2`` Provides PostgreSQL 9.6, PostGIS 2.4, R 3.2

**Note:** We highly recommend that you use tagged versions because
successive minor versions of PostgreSQL write their database clusters
into different database directories - which will cause your database
to appear to be empty if you are using persistent volumes for your
database storage.

## Getting the image

There are various ways to get the image onto your system:

The preferred way (but using most bandwidth for the initial image) is to
get our docker trusted build like this:


```
docker pull corylabiosphere/postgis-plr
```

To build the image yourself without apt-cacher (also consumes more bandwidth
since deb packages need to be refetched each time you build) do:

```
docker build -t corylabiosphere/postgis-plr git://github.com/Shappiro/docker-postgis-plr
```

To build with apt-cacher (and minimise download requirements) you need to
clone this repo locally first and modify the contents of 71-apt-cacher-ng to
match your cacher host. Then build using a local url instead of directly from
github.

```
git clone git://github.com/Shappiro/docker-postgis-plr
```

Now edit ``71-apt-cacher-ng`` then do:

```
docker build -t corylabiosphere/postgis-plr .
```

## Run

To create a running container do:

```
sudo docker run --name "postgis" -p 25433:5433 -d -t corylabiosphere/postgis-plr
```

## Environment variables

You can also use the following environment variables to pass a 
user name, password and/or default database name(or multiple databases coma separated).

* -e POSTGRES_USER=<PGUSER> 
* -e POSTGRES_PASS=<PGPASSWORD>
* -e POSTGRES_DBNAME=<PGDBNAME>
* -e POSTGRES_MULTIPLE_EXTENSIONS=postgis,hstore,postgis_topology # You can pass as many extensions as you need.

These will be used to create a new superuser with
your preferred credentials. If these are not specified then the postgresql 
user is set to 'docker' with password 'docker'.

You can open up the PG port by using the following environment variable. By default 
the container will allow connections only from the docker private subnet.

* -e ALLOW_IP_RANGE=<0.0.0.0/0> By default 
t

Postgres conf is setup to listen to all connections and if a user needs to restrict which IP address
PostgreSQL listens to you can define it with the following environment variable. The default is set to listen to 
all connections.
* -e IP_LIST=<*>


## Convenience docker-compose.yml

For convenience we have provided a ``docker-compose.yml`` that will run a
copy of the database image and also our related database backup image (see 
[https://github.com/kartoza/docker-pg-backup](https://github.com/kartoza/docker-pg-backup)).

The docker compose recipe will expose PostgreSQL on port 25433 (to prevent
potential conflicts with any local database instance you may have).

Example usage:

```
docker-compose up -d
```

**Note:** The docker-compose recipe above will not persist your data on your local
disk, only in a docker volume.

## Connect via psql

Connect with psql (make sure you first install postgresql client tools on your
host / client):


```
psql -h localhost -U docker -p 25433 -l
```

**Note:** Default postgresql user is 'docker' with password 'docker'.

You can then go on to use any normal postgresql commands against the container.

Under ubuntu 16.04 the postgresql client can be installed like this:

```
sudo apt-get install postgresql-client-9.6
```
## Storing data on the host rather than the container.


Docker volumes can be used to persist your data.

```
mkdir -p ~/postgres_data
docker run -d -v $HOME/postgres_data:/var/lib/postgresql corylabiosphere/postgis-plr`
```

You need to ensure the ``postgres_data`` directory has sufficient permissions
for the docker process to read / write it.

## Credits

Tim Sutton (tim@kartoza.com)
Gavin Fleming (gavin@kartoza.com)
Risky Maulana (rizky@kartoza.com)
Admire Nyakudya (admire@kartoza.com)
Aaron Iemma (corylabiosphere@gmail.com)
June 2019
