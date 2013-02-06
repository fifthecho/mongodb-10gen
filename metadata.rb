name             "mongodb-10gen"
maintainer       "Higanworks LLC., Jeff Moody"
maintainer_email "sawanoboriyu@higanworks.com, jmoody@datapipe.com"
license          "MIT"
description      "Installs/Configures mongodb-10gen"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.8"
depends          "apt"
depends			 "yum"
depends          "mongodb-10gen" # workaround for TravisCI
