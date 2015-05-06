#!/bin/bash

# Copyright (c) 2015, Rentabiliweb Group
#
# Permission  to use,  copy, modify,  and/or  distribute this  software for  any
# purpose  with  or without  fee  is hereby  granted,  provided  that the  above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS"  AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO  THIS SOFTWARE INCLUDING  ALL IMPLIED WARRANTIES  OF MERCHANTABILITY
# AND FITNESS.  IN NO EVENT SHALL  THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR  CONSEQUENTIAL DAMAGES OR  ANY DAMAGES WHATSOEVER  RESULTING FROM
# LOSS OF USE, DATA OR PROFITS,  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER  TORTIOUS ACTION,  ARISING  OUT OF  OR  IN CONNECTION  WITH  THE USE  OR
# PERFORMANCE OF THIS SOFTWARE.

if [ ${#} -lt 1 ]
then
    cat <<EOF
${0}: missing version
Usage: ${0} [VERSION]

eg: ${0} 3.0.2
EOF
exit 1
fi

# main variables
VERSION=${1}
DATE=`date +%Y%m%d-%Hh%M`
# default values
REDMINE_PATH='/srv/redmine'
REDMINE_USER='www-data'
REDMINE_GROUP='www-data'
REDMINE_DB='redmine'
RAILS_ENV='production'

if [ -f /etc/redmine.upgrade ]
then
    . /etc/redmine.upgrade
fi

echo -ne "\\033[39m-- check folders in ${REDMINE_PATH}"
# redmine folders
if [ ! -d ${REDMINE_PATH} ]
then
    mkdir -p ${REDMINE_PATH}
else
    cd ${REDMINE_PATH}
    # backup folder
    echo -n ' (backup, '
    if [ ! -d ${REDMINE_PATH}/backup ]
    then
	mkdir -p ${REDMINE_PATH}/backup
    fi
    # shared folders (read README.md)
    echo -n 'shared, '
    if [ ! -d ${REDMINE_PATH}/shared ]
    then
	mkdir -p ${REDMINE_PATH}/shared
    else
	# files folder
	echo -n 'files, '
	if [ ! -d ${REDMINE_PATH}/shared/files ]
	then
	    mkdir -p ${REDMINE_PATH}/shared/files
	fi
	# plugins folder
	echo -n 'plugins, '
	if [ ! -d ${REDMINE_PATH}/shared/plugins ]
	then
	    mkdir -p ${REDMINE_PATH}/shared/plugins
	fi
	# themes folder
	echo -n 'themes)'
	if [ ! -d ${REDMINE_PATH}/shared/public/themes ]
	then
	    mkdir -p ${REDMINE_PATH}/shared/public/themes
	fi
    fi
fi
echo -e "\\033[32m OK"

# backup
echo -ne "\\033[39m-- backup database in ${REDMINE_PATH}/backup/database-${DATE}.sql"
mysqldump ${REDMINE_DB} > ${REDMINE_PATH}/backup/database-${DATE}.sql
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with mysqldump"
else
    echo -e "\\033[32m OK"
fi

# download
echo -ne "\\033[39m-- download redmine version ${VERSION} (redmine-${VERSION}.tar.gz) in /usr/src"
wget -q -O /usr/src/${VERSION}.tar.gz http://www.redmine.org/releases/redmine-${VERSION}.tar.gz
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with wget"
else
    echo -e "\\033[32m OK"
fi

# extract
echo -ne "\\033[39m-- extract redmine version ${VERSION} (redmine-${VERSION}.tar.gz) from /usr/src in ${REDMINE_PATH}"
tar -C ${REDMINE_PATH} -xzf /usr/src/redmine-${VERSION}.tar.gz
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with tar"
else
    echo -e "\\033[32m OK"
fi

# chown / chmod
echo -ne "\\033[39m-- chown & chmod in ${REDMINE_PATH}"
find ${REDMINE_PATH}/redmine-${VERSION} -type d -exec chmod 755 {} \;
find ${REDMINE_PATH}/redmine-${VERSION} -type f -exec chmod 644 {} \;
echo -n " (redmine-${VERSION}, "
chown -R root:root ${REDMINE_PATH}/redmine-${VERSION}
echo -n 'log, tmp)'
chown -R ${REDMINE_USER}:${REDMINE_GROUP} ${REDMINE_PATH}/redmine-${VERSION}/log ${REDMINE_PATH}/redmine-${VERSION}/tmp
echo -e "\\033[32m OK"

# symlink current
echo -ne "\\033[39m-- create current symlink in ${REDMINE_PATH} (redmine-${VERSION})"
cd ${REDMINE_PATH}
if [ -h ${REDMINE_PATH}/current ]
then
    rm ${REDMINE_PATH}/current
    ln -s redmine-${VERSION} current
elif [ -d ${REDMINE_PATH}/current ] || [ -f ${REDMINE_PATH}/current ]
then
    echo -e "\\033[31m KO: current is a folder or file"
fi
cd ${REDMINE_PATH}/current
echo -e "\\033[32m OK"

# symlink files
echo -ne "\\033[39m-- create files symlink in ${REDMINE_PATH}/current (redmine-${VERSION})"
echo -e "\\033[32m OK"

# symlink plugins
echo -ne "\\033[39m-- create plugins symlink in ${REDMINE_PATH}/current (redmine-${VERSION})"
echo -e "\\033[32m OK"

# bundle install
echo -ne "\\033[39m-- bundle install in ${REDMINE_PATH}/current (redmine-${VERSION})"
# bundle install --no-color --without development test > /dev/null
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with bundle install"
else
    echo -e "\\033[32m OK"
fi

# rake generate_secret_token
echo -ne "\\033[39m-- rake generate_secret_token in ${REDMINE_PATH}/current (redmine-${VERSION})"
# bundle exec rake generate_secret_token
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with rake generate_secret_token (bundle exec)"
else
    echo -e "\\033[32m OK"
fi

# rake db:migrate
echo -ne "\\033[39m-- rake db:migrate in ${REDMINE_PATH}/current (redmine-${VERSION})"
# bundle exec rake db:migrate
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with rake db:migrate (bundle exec)"
else
    echo -e "\\033[32m OK"
fi

# rake redmine:plugins:migrate
echo -ne "\\033[39m-- rake redmine:plugins:migrate in ${REDMINE_PATH}/current (redmine-${VERSION})"
# bundle exec rake redmine:plugins:migrate
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with rake redmine:plugins:migrate (bundle exec)"
else
    echo -e "\\033[32m OK"
fi

# rake tmp:cache:clear
echo -ne "\\033[39m-- rake tmp:cache:clear in ${REDMINE_PATH}/current (redmine-${VERSION})"
# bundle exec rake tmp:cache:clear
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with rake tmp:cache:clear (bundle exec)"
else
    echo -e "\\033[32m OK"
fi

# rake tmp:session:clear
echo -ne "\\033[39m-- rake tmp:session:clear in ${REDMINE_PATH}/current (redmine-${VERSION})"
# bundle exec rake tmp:session:clear
if [ $? -ne 0 ]
then
    echo -e "\\033[31m KO: error with rake tmp:session:clear (bundle exec)"
else
    echo -e "\\033[32m OK"
fi
# EOF
