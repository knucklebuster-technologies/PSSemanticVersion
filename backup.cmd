git add --all
git commit -m %1
git push
restic backup -r G:\RESTIC_BACKUP\ .
restic forget -r G:\RESTIC_BACKUP\ --keep-last 2 --prune