#!/bin/bash

# A simple shell script to deploy website files to a remote webserver.
# Customize paths, usernames, and hostnames before running this script.
# You'll have to manually enter your password three times.
# That's intentional.
#
# https://github.com/tcpiplab/push-to-webserver.sh
# 2019-04-24
# Free to re-use or modify


# Automatically set the name of this script so we know to not upload it to the webserver
THIS_SHELL_SCRIPT=${0##*/}

# Customize tarball file name here
TARBALL_FILENAME=webfiles.tar.gz

# Set custom local paths here
LOCAL_WEBROOT=/home/$USER/Repos/www.EXAMPLE.com/webroot
LOCAL_TAR=/bin/tar
LOCAL_SHASUM=/usr/bin/shasum
LOCAL_SSH=/usr/bin/ssh
LOCAL_SCP=/usr/bin/scp
LOCAL_PRINTF=/usr/bin/printf

# Set custom remote paths here
REMOTE_WEBROOT=/PATH-TO-HTDOCS/htdocs/
REMOTE_TAR=/bin/tar
REMOTE_SHASUM=/usr/bin/shasum
REMOTE_GREP=/bin/grep

# Set custom remote web server username here
REMOTE_USER=EXAMPLE_USERNAME

# Set custom remote web server hostname (or IP address) here
REMOTE_WEBSERVER=EXAMPLE-NODE.EXAMPLE-WEBHOST.TLD

# Colors
# GREEN=\e[32m
# RESET_COLOR=\e[0m

# Make sure we're in the correct directory
cd $LOCAL_WEBROOT

$LOCAL_PRINTF "\e[32mCreating local tarball...\n\e[0m"

# Create local tarball. Exclude old tarball, shasum, & this shell script file
$LOCAL_TAR zc --exclude="./$TARBALL_FILENAME*" --exclude="$THIS_SHELL_SCRIPT" --exclude=".gitignore" -f $TARBALL_FILENAME .

$LOCAL_PRINTF "\e[32mCreating local checksum file...\n\e[0m"

# Create a local checksum file for later checking after transferring files
$LOCAL_SHASUM -a 256 $TARBALL_FILENAME > $TARBALL_FILENAME.sha256

$LOCAL_PRINTF "\e[32mReady to upload tarball and checksum file?\n\e[0m"

# Upload the tarball to the webserver
$LOCAL_SCP $TARBALL_FILENAME* $REMOTE_USER@$REMOTE_WEBSERVER:$REMOTE_WEBROOT

$LOCAL_PRINTF "\e[32mReady to check remote checksum file against remote tarball?\n\e[0m"

# Verify checksum after upload
$LOCAL_SSH $REMOTE_USER@$REMOTE_WEBSERVER $REMOTE_SHASUM -c $TARBALL_FILENAME.sha256 | $REMOTE_GREP 'OK$'

# Print an error if the previous command exited non-zero
[ $? -eq 0 ] || $LOCAL_PRINTF "\e[31m$? exited with a non-zero exit status!\n\e[0m"

$LOCAL_PRINTF "\e[32mReady to extract remote tarball and overwrite old files?\n\e[0m"

# Untar the web files on the webserver
$LOCAL_SSH $REMOTE_USER@$REMOTE_WEBSERVER $REMOTE_TAR zxf $TARBALL_FILENAME

$LOCAL_PRINTF "\e[32mWebsite files updated successfully.\n\e[0m"