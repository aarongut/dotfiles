git pull origin master;
git submodule sync;
git submodule update;

rsync --exclude ".git/" --exclude "install.sh" --exclude ".git*" -avhE  --no-perms . ~;

source ~/.bashrc
