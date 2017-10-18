#!/bin/bash
SCRIPT=/root/setup_student_vm_go.sh
wget -O $SCRIPT https://raw.githubusercontent.com/dave-mccowan/sydney-workshop/master/setup_student_vm_go.sh
chmod +x $SCRIPT
. $SCRIPT > /root/setup_go.log
echo Done!
