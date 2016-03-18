#/bin/bash -x

if [ -f /etc/redhat-release ]; then
  sudo yum install -y git tig tmux tree vim
else
  sudo apt-get update
  sudo apt-get install -y git tig tmux tree vim
fi

# Setup .bashrc
grep -c DEBEMAIL ~/.bashrc >/dev/null
if [ "$?" != "0" ]; then
  echo 'export DEBEMAIL="garyr@f5.com"' >> ~/.bashrc
fi
grep -c DEBFULLNAME ~/.bashrc >/dev/null
if [ "$?" != "0" ]; then
  echo 'export DEBFULLNAME="Gary Ritzer"' >> ~/.bashrc
fi
grep -c bash_aliases ~/.bashrc >/dev/null
if [ "$?" != "0" ]; then
  echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bashrc
  echo "  . ~/.bash_aliases" >> ~/.bashrc
  echo "fi" >> ~/.bashrc
fi

# Setup symbolic links
if [ ! -h ~/.bash_aliases ]; then
  ln -sf ~/dotfiles/bash_aliases ~/.bash_aliases
fi

# Configure git.
echo Configuring GIT
if [ ! -h ~/.gitconfig ]; then
  ln -sf ~/dotfiles/gitconfig ~/.gitconfig
fi
if [ ! -h ~/.gitmessage ]; then
  ln -sf ~/dotfiles/gitmessage ~/.gitmessage
fi

# Configure tig
echo Configuring TIG
if [ ! -h ~/.tigrc ]; then
  ln -sf ~/dotfiles/tigrc ~/.tigrc
fi

# Configure slickedit
echo Configuring SLICKEDIT
if [ ! -h ~/.slickedit ]; then
  ln -sf ~/dotfiles/slickedit ~/.slickedit
fi

# Configure vim
echo Configuring VIM
# Install stuff to make YouCompleteMe happy
if [ -f /etc/redhat-release ]; then
  sudo yum install -y epel-release
  sudo yum install -y cmake ctags-etags golang nodejs npm python-devel --enablerepo=epel
else
  sudo apt-get install -y cmake exuberant-ctags golang-go nodejs npm python-dev
fi
if [ ! -h ~/.vimrc ]; then
  ln -sf ~/dotfiles/vimrc ~/.vimrc
fi
if [ ! -h ~/.vim ]; then
  ln -sf ~/dotfiles/vim ~/.vim
fi
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
fi
if [ ! -f ~/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so ]; then
  cd ~/.vim/bundle/YouCompleteMe/
  git submodule update --recursive
  ./install.py --clang-completer --gocode-completer --arch 64
fi
