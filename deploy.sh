#!/bin/bash
hugo --cleanDestinationDir && rsync -avz \
  --exclude='/cv/' \
  --exclude='/cv/*' \
  --exclude='*/raw/' \
  --exclude='*/raw/*' \
  --exclude='impressum.html' \
  --exclude='.htaccess' \
  --delete public/ uber:~/html/
ssh uber << EOF
chmod -R u=rwX,go=rX ~/html
restorecon -R -v ~/html
EOF
