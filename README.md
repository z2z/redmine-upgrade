# redmine-upgrade

[![Build Status](https://travis-ci.org/rentabiliweb/redmine-upgrade.svg)](https://travis-ci.org/rentabiliweb/redmine-upgrade)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Requirements](#requirements)
4. [Setup](#setup)
5. [Usage](#usage)
6. [Development](#development)

## Overview

This is a simple script to upgrade from one Redmine version to another.

## Description

The  script  follow all  the  steps  of the  official  redmine  upgrade guide  :
http://www.redmine.org/projects/redmine/wiki/RedmineUpgrade

## Requirements

On Debian (>= wheezy) & Ubuntu (>= trusy), you need the following packages :

 ```bash
 $> sudo apt-get install mysql-client wget
 ```

## Setup

This script need to have a specifig  files and folders tree, but you can replace
**/srv/redmine** with the folder of your choice.

 ```bash
 $> cd /srv/redmine
 $> ls
 current
 redmine-2.6.1
 redmine-3.0.1
 redmine-3.0.2
 redmine-3.0.3
 shared
 ```

Actually  **current**  is  a symlink  to  the  last  version in  production  and
**shared** is the folder containing files, themes and plugins.

 ```bash
 $> cd /srv/redmine/shared
 $> ls
 files
 plugins
 themes
 ```

There's some default value at the beginning  of the script but you can have your
own in **/etc/redmine.upgrade** file.

 ```bash
 $> cat /etc/redmine.upgrade
 REDMINE_PATH='/var/www/redmine'
 REDMINE_USER='redmine'
 REDMINE_GROUP='www-data'
 REDMINE_DB='redmine'
 RAILS_ENV='production'
 ```

## Usage

You can put  the script everywhere you want.  For this example we put it in the
Redmine's folder.

 ```bash
 $> cd /srv/redmine
 $> upgrade.sh 3.0.3
 ```

You can use the following command to upgrade to the latest version of redmine.

```bash
 $> cd /srv/redmine
 $> upgrade.sh latest
```

## Development

Feel free to contribute :)
