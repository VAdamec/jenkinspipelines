FROM pauldavidgilligan/docker-centos6-puppet-ruby215
MAINTAINER Vaclav Adamec "vaclav.adamec@avg.com"

ADD Puppetfile /
ADD puppet/manifest.pp /
CMD gem install librarian-puppet
RUN librarian-puppet install
RUN puppet apply --modulepath=/modules /manifest.pp
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx"]
