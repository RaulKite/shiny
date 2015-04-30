FROM r-base:latest

MAINTAINER Raul Sanchez "raul@um.es"

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    apache2 \
    apache2-utils 

# Download and install libssl 0.9.8
RUN wget --no-verbose http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
    dpkg -i libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
    rm -f libssl0.9.8_0.9.8o-4squeeze14_amd64.deb

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('shiny', 'dygraphs'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('shiny', 'xts'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('shiny', 'data.table'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('shiny', 'maptools'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('shiny', 'gsw'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages(c('shiny', 'devtools'), repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_github('rstudio/leaflet')"


RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

EXPOSE 3838

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ports.conf /etc/apache2/ports.conf

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
