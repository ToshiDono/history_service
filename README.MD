# README
{<img src="https://travis-ci.org/mkdevprogects/patients.svg?branch=master" alt="Build Status" />}[https://travis-ci.org/mkdevprogects/patients]

Functionality: registration and display of entity changes.

Running:

* Clone app: `git clone git@github.com:mkdevprogects/base.git`
* `cd base/`
* Set the environment variables:
```
  PGUSER  
  PGPASSWORD  
  ENVPOSTGRES_DB  
  VOLUMES  
  ENVPGDATA  
  DB_HOST  
  DB_PG_PORT  
  DB_REDIS_HOST  
  DB_REDIS_PORT  
  HUTCH_MQ_HOST  
  HUTCH_MQ_API_HOST
```  
* `docker-compose -f docker-compose.demo.yml up`
* open browser and go to [http://0.0.0.0:3000/](http://0.0.0.0:3000/) and see patient app
* open browser and go to [http://0.0.0.0:4000/](http://0.0.0.0:4000/) and see manager app
* open browser and go to [http://0.0.0.0:5000/](http://0.0.0.0:5000/) and see history app

or

1. Set the environment variables for all apps:
```
PGUSER
DB_HOST
PGPASSWORD
ENVPOSTGRES_DB
ENVPGDATA
```
2. Clone app: `git clone git@github.com:mkdevprogects/base.git`
3. `cd base/`
4. `docker-compose up -d`
5. `cd ..`
6. Clone app: `git clone git@github.com:mkdevprogects/migrations.git`
7. `cd migrations/`
8. Create database: `rake db:create`
9. Run migrations database: `rake db:migrate`
10. `cd ..`
11. Clone app: `git clone git@github.com:mkdevprogects/patients.git`
12. `cd patients/`
13. Create test data: `rake db:seed`
14. Run app: `rails s -p 3000`
15. `cd ..`
16. Clone app: `git@github.com:mkdevprogects/history_service.git`
17. `cd history_service/`
18.  Run app: `foreman start`
19. Create illness request:
   19.1. Open browser and go to [http://0.0.0.0:3000/](http://0.0.0.0:3000/) 
   19.2. Register or log in(`patient.1.@patient.com` / `123123`) to app
   19.3. Create illness request

or

   19.1. Send query

`curl -X POST \
   http://0.0.0.0:5000/event \
   -H 'cache-control: no-cache' \
   -F actor_id=1 \
   -F actor_type=admin \
   -F action=delete \
   -F subject_id=20 \
   -F subject_type=symptom`
   
20. open browser and go to [http://0.0.0.0:5000/events](http://0.0.0.0:5000/events) and see history app

Example environment variables:
```
PGUSER=postgres
PGPASSWORD=12345
ENVPOSTGRES_DB=mkdev_dev
VOLUMES=/Users/user_name/pg_data
ENVPGDATA=/Users/user_name/pg_data
DB_HOST=postgres
```
for running only this app use `DB_HOST=localhost`
```
DB_PG_PORT=5432
DB_REDIS_HOST=redis
DB_REDIS_PORT=6379
```
Set this environment variables if you run all apps:
```
HUTCH_MQ_HOST=rabbitmq
HUTCH_MQ_API_HOST=rabbitmq
```
