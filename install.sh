git pull origin master;
git submodule init;
git submodule sync;
git submodule update;

cd .vim/bundle/vimproc.vim && make && cd ../../..

rsync --exclude ".git/" --exclude ".git*" --exclude "install.sh" --exclude "py3status" --exclude "bin/" -avhE  --no-perms . ~;
