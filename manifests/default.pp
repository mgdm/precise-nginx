group { "puppet":
	ensure => "present",
}

class { 'apt': }

exec { 'apt-get update':
    command => "/usr/bin/apt-get update"
}

include phpPackages
class phpPackages {
	apt::ppa { 'ppa:ondrej/php5': }

	$phpModules = [
		'php-apc',
		'php5-cli',
		'php5-curl',
		'php5-dev',
		'php5-gd',
		'php5-imagick',
		'php5-mcrypt',
		'php5-memcached',
		'php5-mysqlnd',
		'php5-sqlite',
		'php5-tidy',
		'php5-xdebug',
		]

		package { $phpModules:
			ensure => latest,
			notify => Service['php5-fpm'],
			require => Apt::Ppa['ppa:ondrej/php5'],
		}
}

class { 'phpfpm':
  require => Class['phpPackages']
}

nginx::vhost { 'dev.mgdm':
	root => '/vagrant/www',
	index => 'index.php',
	template => 'nginx/vhost.php.conf.erb',
	fastcgi_socket => 'unix:/var/run/php5-fpm.sock',
}

service { 'apache2':
	ensure => stopped,
    require => Class['phpPackages'],
	notify => Service['nginx']
}

package { 'apache2':
	ensure => absent,
	require => Service['apache2']
}

class { 'mysql': 
	require  => Exec['apt-get update']
}

class { 'mysql::server': 
	config_hash => { 'root_password' => 'helloiamroot' },
	require  => Exec['apt-get update']
}
