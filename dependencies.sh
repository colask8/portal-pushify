#!/bin/bash
echo 'Installing system level dependencies..';


# Install and upgrade pip2
yum -y install python-pip
pip2 install --upgrade pip