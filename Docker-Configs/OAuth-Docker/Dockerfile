# Using python 3.7-slim-buster for small size.
FROM python:3.7-slim-buster

# Copy the Contents of the bank folder.
COPY bank bank 
WORKDIR /bank

# Create Environment and Install Dependancies.
ENV NAME bank
RUN pip3 install -r requirements.txt

# Migration
RUN python manage.py makemigrations
RUN python manage.py migrate

# Running Server
CMD  ["python","manage.py","runserver","0.0.0.0:8000"]
