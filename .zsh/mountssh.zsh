if which sshfs > /dev/null; then
  mountssh () { sudo sshfs -o allow_other,defer_permissions,IdentityFile=$HOME/.ssh/id_rsa $1:$2 $HOME/Desktop/SSH }
  umountssh () { sudo umount $HOME/Desktop/SSH }
fi
