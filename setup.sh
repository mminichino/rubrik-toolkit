#!/bin/sh
#
USERNAME=""

if [ -f /etc/os-release ]; then
   . /etc/os-release
   case $NAME in
     "CentOS Linux")
       ;;
     "Red Hat Enterprise Linux")
       ;;
     "Oracle Linux Server")
       ;;
     *)
       echo "OS $NAME not supported."
       exit 1
       ;;
   esac
else
   echo "Can not determine OS version."
   exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
   echo "Script must be run as root."
   exit 1
fi

while getopts "u:" opt
do
  case $opt in
    u)
      USERNAME=$OPTARG
      id -u $USERNAME > /dev/null 2>&1
      [ $? -ne 0 ] && echo "User $USERNAME does not exist." && exit 1
      ;;
    \?)
      err_end "Usage: $0 [ -u user ]"
      ;;
  esac
done

LOGFILE=$(mktemp)

echo "Log file: $LOGFILE"
echo "OS: $NAME"

echo -n "Install python ..."
yum -y install python36 >> $LOGFILE 2>&1
[ $? -ne 0 ] && echo "Can not install python-setuptools" && exit 1
echo "Ok."

echo -n "Install python-setuptools ..."
yum -y install python3-setuptools >> $LOGFILE 2>&1
[ $? -ne 0 ] && echo "Can not install python-setuptools" && exit 1
echo "Ok."

echo -n "Install python-pip ..."
yum -y install python3-pip >> $LOGFILE 2>&1
[ $? -ne 0 ] && echo "Can not install python-pip" && exit 1
echo "Ok."

echo -n "Install epel-release ..."
yum -y install epel-release >> $LOGFILE 2>&1
[ $? -ne 0 ] && echo "Can not install epel-release" && exit 1
echo "Ok."

echo -n "Install ansible ..."
yum -y install ansible >> $LOGFILE 2>&1
[ $? -ne 0 ] && echo "Can not install ansible" && exit 1
echo "Ok."

echo -n "Install rubrik_cdm ..."
pip3 install rubrik_cdm >> $LOGFILE 2>&1
[ $? -ne 0 ] && echo "Can not install rubrik_cdm" && exit 1
echo "Ok."

echo -n "Install rubrikinc.cdm ..."
ansible-galaxy collection install rubrikinc.cdm >> $LOGFILE 2>&1
[ $? -ne 0 ] && echo "Can not install rubrikinc.cdm" && exit 1
echo "Ok."

if [ -n "$USERNAME" ]; then
   echo -n "Install rubrikinc.cdm as $USERNAME ..."
   su -c 'ansible-galaxy collection install rubrikinc.cdm' $USERNAME >> $LOGFILE 2>&1
   [ $? -ne 0 ] && echo "Can not install rubrikinc.cdm as $USERNAME" && exit 1
   echo "Ok."
fi
