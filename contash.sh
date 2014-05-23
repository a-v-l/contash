#!/bin/bash
# Create new MySQL database,
# download & install latest stable Conato to $DOCUMENTROOT/www.$PROJECT.$TLD/contao
# and link "public" to "contao"

# Environment-configurable variables
MYSQLUSER=root
MYSQLPASS=rootPW
CMSUSER=user
CMSPASS=userPW
HOST=localhost
DBPREFIX=contao_
DOCUMENTROOT=$HOME/www
LANG=de
MYSQL=`which mysql`

# Check for arguments
if [ $# -lt 2 ]
then
  echo "USAGE: $0 project/domainname tld";
  echo "New MySQL database requires first argument (the name of the project to create a development database for = domain name)."
  echo "New Contao site requires second argument (the top level domain of the domain)."
  echo "Aborting..."
  exit
fi

PROJECT="$1"
TLD="$2"

Q1="CREATE DATABASE IF NOT EXISTS $DBPREFIX$PROJECT;"
Q2="GRANT ALL ON $DBPREFIX$PROJECT.* TO '$CMSUSER'@'$HOST' IDENTIFIED BY '$CMSPASS';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}"

# Execute database creation
$MYSQL -u$MYSQLUSER -p$MYSQLPASS -e "$SQL"

# Check whether database was created
RESULT=$($MYSQL -u$PROJECT -p$PROJECT -e "SHOW DATABASES LIKE '$DBPREFIX$PROJECT';")
if [ -n "$RESULT" ]
then
  echo "A database has been created with the name set to $DBPREFIX$PROJECT."
  echo "User set to $CMSUSER and password set to $CMSPASS."
else
  echo "Oups – Something went wrong! The database could not be created or the new user has no access."
  echo "Aborting..."
  exit
fi

SITE="www.$PROJECT.$TLD"

# Create project directory in $DOCUMENTROOT
echo "Creating $DOCUMENTROOT/$SITE"
mkdir "$DOCUMENTROOT/$SITE"

# Download and extract latest stable Contao
curl -Lo $DOCUMENTROOT/$SITE/contao.zip https://github.com/contao/core/archive/master.zip
unzip -q $DOCUMENTROOT/$SITE/contao.zip
rm $DOCUMENTROOT/$SITE/contao.zip

# Read current version from CHANGELOG.md
VERS=$(grep -om 1 "Version \([0-9].\)*" $DOCUMENTROOT/$SITE/core-master/system/docs/CHANGELOG.md)
VERS=${VERS:8}

# Move core-master to contao/[current version]
mkdir $DOCUMENTROOT/$SITE/contao
mv  $DOCUMENTROOT/$SITE/core-master $DOCUMENTROOT/$SITE/contao/$VERS

# Create public symlink to contao/[current version]
ln -s $DOCUMENTROOT/$SITE/contao/$VERS $DOCUMENTROOT/$SITE/public
