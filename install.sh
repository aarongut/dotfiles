git pull origin master;

rsync --exclude ".git/" --exclude "install.sh" -avhE  --no-perms . ~;

source ~/.bashrc
