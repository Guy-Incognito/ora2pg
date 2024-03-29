# How to Upgrade 

+ Adapt version in Dockerfile
+ Run Container
+ Test migration against sample database
+ Copy `/etc/ora2pg/ora2pg.conf.dist` from built container to `/config/ora2pg.con` in repo
E.g.: `docker cp ora2pg:/etc/ora2pg/ora2pg.conf.dist $(pwd)/config/`
+ Create Tag for Version