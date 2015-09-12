class appdev::php
{
	class { "::php::cli": }
	class { '::php::mod_php5': }
	php::ini { '/etc/php.ini':
		display_errors => 'On',
		date_timezone => 'America/Chicago',
		error_reporting => 'E_ALL & ~E_NOTICE & ~E_DEPRECATED',
		short_open_tag => 'On',
		memory_limit => '128M',
		file_uploads => 'On',
		upload_max_filesize => '16M',
		allow_url_fopen => 'On',
		html_errors => 'On'
	}
	php::module { [
			'devel',
			'gd',
			'mcrypt',
			'intl',
			'mbstring',
			'mysql',
			'pdo',
			'pear',
			'soap',
			'xml',
			'pecl-memcache',
			'pecl-xdebug',
			'pear-Net-Curl',
			'pecl-xhprof',
			'php-phpunit-PHPUnit',
			'php-phpunit-PHPUnit-MockObject',
			'process'
		]:
		require => [ Class['php::cli'], Yumrepo['epel'] ]
	}
	class { '::composer':
		command_name => 'composer',
		target_dir   => '/usr/local/bin',
		require => Class['php::cli']
	}
}