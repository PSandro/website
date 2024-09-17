#!/bin/bash
hugo && rsync -avz --delete public/ uber:~/html/
ssh uber << EOF
chmod -R u=rwX,go=rX ~/html
restorecon -R -v ~/html
EOF
