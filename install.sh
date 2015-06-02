git pull origin master;

rsync --exclude ".git/" --exclude "install.sh" --exclude ".git*" -avhE  --no-perms . ~;

source ~/.bashrc
