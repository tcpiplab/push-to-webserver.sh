# push-to-webserver.sh

## A simple shell script to deploy website files to a remote webserver.

### Install
1. Copy the `push-to-webserver.sh` file to the directory on your local system (e.g. laptop) where you edit your website files.
    ```shell
    git clone git@github.com:tcpiplab/push-to-webserver.sh.git
    ```
2. Set the executable bit on this script.
    ```shell
    chmod u+x push-to-webserver.sh
    ```

### Customize
Customize the hardcoded variables at the top of the script. This will set the paths, usernames, and hostnames that you need to configure before running this script.

### Run
***You'll have to manually enter your password three times. That's intentional so that you don't blindly copy broken files to your live webserver.***
```shell
$ ./push-to-webserver.sh 
Creating local tarball...
Creating local checksum file...
Ready to upload tarball and checksum file...
EXAMPLE_USERNAME@EXAMPLE_WEBSERVER's password: **********
webfiles.tar.gz                      100% 2917KB 679.5KB/s   00:04    
webfiles.tar.gz.sha256               100%   82     1.4KB/s   00:00    
Ready to check remote checksum file against remote tarball...
EXAMPLE_USERNAME@EXAMPLE_WEBSERVER's password: **********
webfiles.tar.gz: OK
Ready to Extract remote tarball and overwrite old files...
EXAMPLE_USERNAME@EXAMPLE_WEBSERVER's password: **********
Website files updated successfully.
```