FROM python:3.5
ENV PYTHONUNBUFFERED 1
RUN mkdir /app
WORKDIR /app
ADD ./sample/ /app
EXPOSE 5000
RUN pip install -r requirements.txt
