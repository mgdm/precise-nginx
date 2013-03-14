group { "puppet":
	ensure => "present",
}

$phpModules = ['php5-cli', 'php5-curl', 'php5-dev', 'php5-gd', 'php5-imagick', 'php5-mcrypt', 'php5-memcached', 'php5-mysqlnd', 'php5-sqlite', 'php5-tidy']

package { $phpModules:
  ensure => latest,
  notify => Service['php5-fpm']
}

class { 'phpfpm': }

nginx::vhost { 'dev.mgdm':
	root => '/vagrant/www',
	index => 'index.php',
	template => 'nginx/vhost.php.conf.erb',
}

class { 'mysql': }

class { 'mysql::server': 
	config_hash => { 'root_password' => 'helloiamroot' }
}
