name             'set_hostname'
maintainer       'Jon A'
maintainer_email 'three18ti@gmail.com'
license          'MIT'
description      'Configures hostname'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

supports 'debian'
supports 'ubuntu'

depends 'hostsfile'
