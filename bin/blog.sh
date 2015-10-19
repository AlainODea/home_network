#!/bin/bash
time ssh root@smartos01 'vmadm create' < machines/blog.json
time ssh -A -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' root@blog -t "
  pkgin -y update
  pkgin -y full-upgrade
  pkgin -y install erlang rebar postgresql94-server ImageMagick build-essential git unzip
  groupadd zotonic
  useradd -m -s /usr/bin/bash -G zotonic zotonic
  passwd -N zotonic
  cp /{root,home/zotonic}/.ssh/authorized_keys
  chown -R zotonic:zotonic /home/zotonic/.ssh
"
time scp -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' -r blog/* root@blog:/
time ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' root@blog "
  curl -OL https://github.com/emcrisostomo/fswatch/releases/download/1.6.0/fswatch-1.6.0.tar.gz
  tar xf fswatch-1.6.0.tar.gz
  pushd fswatch-1.6.0
  ./configure --prefix=/opt/local
  # fixed in #99 so won't be necessary in fswatch 1.6.2 likely
  patch libfswatch/src/libfswatch/c++/inotify_monitor.cpp < /root/fswatch_illumos.patch
  make
  make install
  popd
  svcadm enable -s postgresql:default
  sleep 10
  su - postgres -c psql <<EOF
    CREATE USER zotonic WITH PASSWORD '';
    CREATE DATABASE zotonic_blog WITH OWNER = zotonic ENCODING = 'UTF8';
    GRANT ALL ON DATABASE zotonic_blog TO zotonic;
EOF
"
time ssh -A -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' zotonic@blog '
  set +x
  # explicitly trust current github.com host key (automated TOFU)
  ssh-keyscan -H github.com >> ~/.ssh/known_hosts
  git clone git@github.com:AlainODea/blog.alainodea.com.git
  pushd blog.alainodea.com
  git submodule init
  git submodule update
  popd
  cp config.in config
  psql zotonic_blog < zotonic_blog.sql
  popd
  git clone https://github.com/zotonic/zotonic.git
  pushd zotonic
  git checkout release-0.13.4
  mkdir -p user/sites
  pushd user/sites
  ln -s /home/zotonic/blog.alainodea.com blog
  popd
  make
  popd
'
time ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' root@blog "
  svccfg import /opt/local/lib/svc/manifest/zotonic.xml
  svcadm enable zotonic
  echo \"visit http://\$(hostname)/\"
"
