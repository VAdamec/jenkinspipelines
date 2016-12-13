FROM volanja/docker-ruby2.2.0
MAINTAINER Vaclav Adamec "vaclav.adamec@avg.com"

RUN yum -y install wget && wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RUN rpm -i epel-release-latest-6.noarch.rpm | exit 0
RUN yum install python  python-pip -y
RUN gem install serverspec --no-ri --no-rdoc

COPY ./ /code
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
WORKDIR /code
