#!/bin/sh

set -xeu

cd /home/isucon/torb
git pull
cd webapp/ruby
bundle
sudo systemctl restart torb.ruby
