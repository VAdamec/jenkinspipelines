FROM pauldavidgilligan/docker-centos6-puppet-ruby215
MAINTAINER Vaclav Adamec "vaclav.adamec@avg.com"

ADD Puppetfile /
ADD puppet/manifest.pp /
ADD puppet/hiera.yaml /etc/puppet/hiera.yaml
ADD puppet/frontend.yaml /etc/puppetlabs/code/common.yaml
CMD gem install librarian-puppet
RUN librarian-puppet install --verbose
RUN puppet apply --debug --modulepath=/modules /manifest.pp
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx"]
