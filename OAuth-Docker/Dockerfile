# Using python 3.7 alpine for small size.
FROM python:3.7-alpine

# Python Docker Image has an Issue with NUMPY and PANDAS package. So this is a work around.
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --update --no-cache py3-numpy py3-pandas@testing

# Copy the Contents of the bank folder.
COPY bank bank 
WORKDIR /bank

# Since NUMPY and PANDAS are already installed, Make sure our requirements.txt doesn't have PANDAS or NUMPY
RUN cat requirements.txt | sed '/numpy/d' | sed '/pandas/d' > requirements.txt 
RUN pip3 install -r requirements.txt

# Migration
RUN python manage.py makemigrations
RUN python manage.py migrate

# Running Server
CMD  ["python","manage.py","runserver","0.0.0.0:8000"]
