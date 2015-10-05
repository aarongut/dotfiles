git pull origin master;
git submodule init;
git submodule sync;
git submodule update;

rsync --exclude ".git/" --exclude ".git*" --exclude "install.sh" --exclude "py3status" -avhE  --no-perms . ~;

source ~/.bashrc
