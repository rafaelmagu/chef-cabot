name             'cabot'
maintainer       'Rafael Fonseca'
maintainer_email 'rafael.magu@gmail.com'
license          'MIT'
description      'Installs and configures Cabot'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.2'

depends 'build-essential', '~> 2.0.4'
depends 'git', '~> 4.0.2'
depends 'nginx', '~> 2.7.4'
depends 'nodejs', '~> 1.3.0'
depends 'npm', '~> 0.1.2'
depends 'python', '~> 1.4.6'
depends 'redis', '~> 3.0.4'
depends 'ubuntu', '~> 1.1.6'
