FROM httpd:latest


# Update and install mod-security2 
RUN apt-get update && apt-get install -y libapache2-mod-security2

WORKDIR /usr/local/apache2

COPY crs-setup.conf.example setup.sh mod_evasive24.so mod_security2.so httpd.conf ./

COPY rules ./rules

# Make executable
RUN chmod +x setup.sh
RUN ./setup.sh

EXPOSE 80 443

CMD ["httpd-foreground"]
