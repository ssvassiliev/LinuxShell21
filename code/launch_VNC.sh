#!/bin/bash
# Save X-server config and copy into startup folder press windows+r  type shell:startup

usage ( ) { echo -e "\nUsage: ./$(basename $0) -s graham.computecanada.ca -n gra798\n"; }

while getopts 's:n:' OPTION; do
  case "$OPTION" in
    s)
      echo "Cluster=$OPTARG"
      Host=$OPTARG
      ;;

    n)
      echo "Node=$OPTARG"
      Node=$OPTARG
      ;;
  esac
done

if [ $# -ne 4 ]
then
    usage
    exit 1
fi

if [ ! -d ~/.vnc ]; then
  echo "Creating ~/.vnc"
  mkdir ~/.vnc
fi

have_passwd=`ssh $Host 'test -f .vnc/passwd; echo $?'`
if [ -f ~/.vnc/passwd ]; then
  echo "Sending VNC passwd to $Host .."
  scp $HOME/.vnc/passwd $Host:.vnc
elif [ $have_passwd -eq 0 ]; then
  echo "Fetching VNC password from $Host .. "
  scp  $Host:.vnc/passwd $HOME/.vnc/
else
  echo -e "\n ** ERROR ** VNC password does not exist. \nLog in to $Host and type 'vncpasswd' to create it\n"
  rm -f $HONE/.vnc/passwd
  exit 1
fi

echo "Launching VNC server on $Node .. "
# Copy ~/.vnc/passwd file from the remote to the local machine
PasswordFile=$HOME/.vnc/passwd
#Node=$1
#Host=siku.ace-net.ca
#Host=graham.computecanada.ca

vncviewer_MacOS() {
/Applications/TigerVNC\ Viewer\ 1.11.0.app/Contents/MacOS/TigerVNC\ Viewer -passwd $PasswordFile localhost:$1
}

vncviewer_CentOS() {
vncviewer -passwd $PasswordFile localhost:$1
}

P=$(ssh -o StrictHostKeyChecking=no -J $Host $Node 'vncserver >& t;  grep port $(grep "Log file" t | cut -f 4 -d " ") | grep -Eo "[0-9]{1,6}"; rm t')
echo -e "\nvncserver is listening at $Node:$P"
ssh -f -o ExitOnForwardFailure=yes $Host -L $P:$Node:$P sleep 1
echo "opening SSH tunnel to $Node .."
vncviewer_MacOS $P
echo Terminating all vnc sessions ..
SESSION=`LANG=C ssh -J $Host $Node vncserver -list | grep ^: | cut -f 1`
for i in $SESSION
 do
  echo Ternimating session $i
  LANG=C ssh -J $Host $Node "vncserver -kill $i"
 done
ssh -J $Host $Node "rm -f $HOME/.vnc/*.log"
