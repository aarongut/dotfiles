git pull origin master;
git submodule sync;
git submodule update;

rsync --exclude ".git/" --exclude ".git*" --exclude "install.sh" -avhE  --no-perms . ~;

source ~/.bashrc
