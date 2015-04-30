Docker for Shiny Server
=======================

This is a Dockerfile for Shiny Server on Debian "testing". It is based on the r-base image.

The image is available from [Docker Hub](https://registry.hub.docker.com/u/raulkite/shiny/).

## Usage:

To run a temporary container with Shiny Server:

```sh
docker run --rm -p 3838:3838 raulkite/shiny
```


To expose a directory on the host to the container use `-v <host_dir>:<container_dir>`. The following command will use one `/srv/shinyapps` as the Shiny app directory and `/srv/shinylog` as the directory for logs. Note that if the directories on the host don't already exist, they will be created automatically.:

```sh
docker run --rm -p 3838:3838 \
    -v /srv/shinyapps/:/srv/shiny-server/ \
    -v /srv/shinylog/:/var/log/ \
    raulkite/shiny
```

If you have an app in /srv/shinyapps/appdir, you can run the app by visiting http://localhost:3838/appdir/. (If using boot2docker, visit http://192.168.59.103:3838/appdir/)


In a real deployment scenario, you will probably want to run the container in detached mode (`-d`) and listening on the host's port 80 (`-p 80:3838`):

```sh
docker run -d -p 80:3838 \
    -v /srv/shinyapps/:/srv/shiny-server/ \
    -v /srv/shinylog/:/var/log/ \
    raulkite/shiny
```

If you want to protect the web, you should use SHINY\_USER and  SHINY\_PASSWORD like this:

```sh
docker run -d -p 80:3838 \
    -v /srv/shinyapps/:/srv/shiny-server/ \
    -v /srv/shinylog/:/var/log/ \
    -e SHINY_USER=user 
    -e SHINY_PASSWORD=password \
    raulkite/shiny 
```


## Trademarks

Shiny and Shiny Server are registered trademarks of RStudio, Inc. The use of the trademarked terms Shiny and Shiny Server and the distribution of the Shiny Server through the images hosted on hub.docker.com has been granted by explicit permission of RStudio. Please review RStudio's trademark use policy and address inquiries about further distribution or other questions to permissions@rstudio.com.

## Thanks

This docker image is based on the rocker/shiny original image
