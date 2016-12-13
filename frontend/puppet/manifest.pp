class { 'nginx': }

nginx::resource::upstream { 'app':
  members => [
    'app:5000',
  ],
}

nginx::resource::vhost { 'swarm.service.dc1.consul':
  listen_port => 80,
  proxy       => 'http://app',
}
