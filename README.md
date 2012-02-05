# Shoulder Surfer

Quick ruby util that uploads local screenshots in a directory to an sftp server.

# Usage

Combine with unix `watch` to automatically upload screenshots.
Assumes you're using public key crypto; add a :password argument to SFTP.start() if needed.

`$ watch -n time ./watch.rb [--quiet] /a/local/dir/ user@remote_host:/remote_directory/`
