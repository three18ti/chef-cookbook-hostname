name             'set_hostname'
maintainer       'Jon A'
maintainer_email 'three18ti@gmail.com'
license          'MIT'
description      'Configures hostname'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

supports 'debian'
supports 'ubuntu'
supports 'rhel'
supports 'fedora'

depends 'hostsfile'
