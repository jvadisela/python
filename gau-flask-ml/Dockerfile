FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y python3.7 
RUN apt-get install -y python-pip 
RUN apt-get install -y python-dev

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app

ENTRYPOINT [ "python" ]

CMD [ "gau/app.py" ]
