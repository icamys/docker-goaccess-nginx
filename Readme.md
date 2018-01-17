## Dockerized Goaccess + GeoIP + Nginx ##

### Installation ###

1. Create empty access.log file:

    ```
    $ mkdir -p log/nginx
    $ touch log/nginx/access.log
    ```

2. Run docker-compose:
    
    ```
    $ docker-compose up -d
    ```

3. Browse

    - your application on `http://127.0.0.1:8080`
    - goaccess on `http://127.0.0.1:37890/goaccess`

--------

### Optionally ###

1. Edit access file for goaccess:
   
   ```
   $ vim config/nginx/access.conf
   ```

2. Change GeoIP library to enterprise version in Dockerfile.
