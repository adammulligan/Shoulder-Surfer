# Shoulder Surfer

Quick ruby util that uploads local screenshots in a directory to an sftp server.

# Usage

Combine with unix `watch` to automatically upload screenshots.

`$ watch -n time ./watch.rb -d screenshot_dir -D remote_dir -r remote_user@host`
