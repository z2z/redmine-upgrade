# redmine-upgrade

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Development](#development)

## Overview

This is a simple script to upgrade from one Redmine version to another.

## Description

## Setup

This script need to have a specifig  files and folders tree, but you can replace
'/srv/redmine' with the folder of your choice.

 ```sh
 $> cd /srv/redmine
 $> ls
 current
 redmine-2.6.1
 redmine-3.0.1
 redmine-3.0.2
 redmine-3.0.3
 shared
 ```

Actually 'current' is  a symlink to the last version  in production and 'shared'
is the folder containing files, themes and plugins.

 ```sh
 $> cd /srv/redmine/shared
 $> ls
 files
 plugins
 themes
 ```

## Usage

 ```sh
 $> cd /srv/redmine
 $> update.sh 3.0.3
 ```

## Development

Feel free to contribute on GitHub.
