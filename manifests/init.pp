class appdev(
	$root_pwd,
	$dbname,
	$dbuser,
	$dbpassword,
	$app_folder
)
{
	service {
		'firewalld':
			ensure => stopped,
			enable => false
			;
	}
	package{
		[
			'vim-enhanced',
			'screen',
			'git'
		]:
			ensure => present,
			require => Yumrepo['epel']
			;
	}

	yumrepo {
	    'epel':
	        descr       => 'Extra Packages for Enterprise Linux 7 - $basearch',
	        enabled     => "1",
	        gpgcheck    => "1",
	        failovermethod => 'priority',
	        gpgkey      => "https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7",
	        mirrorlist  => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch'
	        ;
	}

	class { 'selinux':
			mode => 'disabled'
		}

	class { '::apache': }
	apache::vhost { "app.dev":
		port    => '80',
		default_vhost => true,
		docroot => "/var/www/$app_folder/public_html",
		docroot_group => "vagrant",
		docroot_owner => "vagrant",
		directories => [
			{
				path => "/var/www/$app_folder/public_html",
				allow_override => ['All'],
				options => ['Indexes','FollowSymLinks'],
				index_options     => ['FancyIndexing']
			}
		],
		require => File["/var/www/$app_folder"]
	}
	class { 'php': }
	class { 'wp::cli': }
	class {
		'mysql':
			root_pwd => $root_pwd,
			dev_db_name => $dbname,
			dev_db_user => $dbuser,
			dev_db_pwd => $dbpassword
			;
	}
	file {
		"/var/www/$app_folder":
			ensure => link,
			target => '/data',
			require => Class['::apache']
			;
	}
}