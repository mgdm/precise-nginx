group { "puppet":
	ensure => "present",
}

class { 'phpfpm': }

nginx::vhost { 'dev.mgdm':
	root => '/vagrant/www',
	index => 'index.php',
	template => 'nginx/vhost.php.conf.erb',
}


