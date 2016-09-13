#! /bin/bash
#Author : Mangesh Bharsakle <mangeshsoft0@gmail.com>
#Date   :05/09/2014
   echo "                 Server Report                   "

         echo "Date:                                      Prepared By: `whoami`  "

         echo "                                                                  "

         BasicInfo()
 {
         echo " Basic Server Information "
         echo " ---------------------------------"
         IP=`hostname -i`
         host=`hostname`
         OS=`uname -o | cut -d "/" -f 2`
         kernel=`uname -r`
         arch=`uname -i`
         echo "  IP           :$IP"
         echo "  Hostname     :$host "
         echo "  OS           :$OS"
         echo "  Kernel       :$kernel"
         echo "  Architecture :$arch "
 }
  Blank()
 {

         echo "                      "
 }

 BasicInfo_2()
 {
         uptime=`uptime | cut -d " " -f 4,5,6,7`
         clogusr=` who | tr -s " " | cut -d " " -f 1 | sort  | uniq| wc -l`
         total_RAM=`free -m | head -2 | tail -1 | tr -s " " | cut -d " " -f 2`
         used_RAM=` free -m | head -2 | tail -1 | tr -s " " | cut -d " " -f 3`
         cp_count=`ps -ef | grep -vw TIME | wc -l`
         cpuuse=`iostat -c | sed -n '3,4p' | tail -1 |awk '{ print $6 }'`
         cpu=`bc <<< 100-$cpuuse`
         uptime | tr -s " " | cut -d " " -f 11,12,13 | sed 's/,/ /g' > uptimedata
         sys_load=`awk -F ' ' '{ printf " %s (1minute) %s(5 minutes)  %s(15mimutes)\n" ,$1, $2,$3 }' uptimedata`

         echo "  Up Time          :$uptime "
         echo "  Current Users    :$clogusr"
         echo "  Current Process  :$cp_count"
         echo "  CPU Usages       :$cpu%"
         echo "  Memory Usage     :Total RAM:$total_RAM Used RAM:$used_RAM"
 echo "  System Load      :$sys_load"
 }
  Top()
 {
        echo "  Process Load (process taking higher resources  "
        echo "---------------------------------------------"
        Pro_load=`top | head -17 | tail -11`
        echo "  $Pro_load"
 }

  CurrentUsers()
 {

   echo "List of Users Currently Logged In (Sorted by Number of Sessions)"
        who | tr -s " " | cut -d " " -f 1 | sort  | uniq > userdata
# echo -n `who | grep mangeshk | wc -l` >> session && echo "  mangeshk" >> session
        touch > session 2> /dev/null
        echo "Sessions     Username"
      for i in $(cat userdata)
      do
#       echo "$i"
             echo -n `who | grep $i | wc -l` >> session && echo "           $i" >> session
                #sed -i 's/^/  /' sessioni
                 #sed -i 's/^/  /' session
     done
             s=`sort -rn session`  > /dev/null

             echo "$s" > session2
             sed -i 's/^/    /' session2
             cat session2
             echo "======================================================================================"



}
  Lvm_Info()
{

    lvdisplay 2> /dev/null| grep "LV Name" | tr -s " " | cut -d" " -f4 > path

    cat path | cut -d "/" -f4 > tmppath
    > mount
   for i in $(cat tmppath)

 do
 grep -i "$i" /etc/fstab | cut -d" " -f2 >> mount

 done


 lvdisplay 2> /dev/null| grep "VG Name" | tr -s " " | cut -d " " -f4 > vg

 lvdisplay 2> /dev/null| grep "LV Size" | tr -s " " | cut -d " " -f4,5 > size


 paste     path    vg    size     mount > lvm

 echo "   LVM Information "
 echo "---------------------"

 echo " LV                       VG               Size          Mount Point"
 echo "-----------           -----------        ----------   -------------------"
 # cat lvm

  cat lvm  | awk '{print $1 "           " $2 "            " $3$4"         "$5}'

 }
  Pv_Info()
{
  echo "PV Information"
  echo "----------------------------------------------------------------------------------------------"
  echo "    PV                    VG                    Size"
  echo "---------------       ----------------       -------------------------"

    pvdisplay 2> /dev/null| grep "PV Name" | awk '{print "    "$3}' > pvname


    pvdisplay 2> /dev/null| grep "VG Name" | awk '{print "      "$3}' > pvgname


    pvdisplay 2> /dev/null| grep "PV Size" | awk '{print "               "$3 $4}' > pvsize

    paste pvname pvgname pvsize > pvdisplay.txt

    cat pvdisplay.txt
 }
  Io_Stat()
{
    iowait=`iostat | head -4 | tail -1 | tr -s " " | cut -d" " -f5`
             echo " I/O  Statistics "
    echo " -------------------"

    echo "    CPU Average I/O Wait:  $iowait%"

    count=`iostat | wc -l`
    count=`expr $count - 5`

    iostat | tail -$count | cut -c1-9,25-35,37-49

 }
  User_Information()
{
  Total_Users()

 {
    grep [5-9][0-9][0-9] /etc/passwd | cut -d ":" -f1  > username
    cusr=`cat username | wc -l`

    echo "  Total Number of User " $cusr

 }
 Total_Users
 SuperUsers()
 {

   cat /etc/passwd | cut -d ":" -f1,3 | grep -w [0] | cut -d ":" -f1  > superu.txt

   echo -n "  Total Number of Super Users : `cat superu.txt | wc -w ` ("  `cat superu.txt` && echo ")"


 }
 SuperUsers
  SudoUsers()
 {


    > sudolist.txt
    grep [5-9][0-9][0-9] /etc/passwd | cut -d ":" -f1  > username

    for i in $(cat username)

  do
grep -w $i /etc/sudoers > /dev/null

  if [ $? -eq 0 ]; then

     echo -n " $i"  >> sudolist.txt


  fi
  done
  echo "  List Of  Sudo Users         : `cat sudolist.txt | wc -w` (`cat sudolist.txt`) "

  }
  SudoUsers
  SudoGroups()
 {
  > sudogroups

  > group.txt
  grep [5-9][0-9][0-9] /etc/group | cut -d ":" -f1 > sudogroups

  for i in $(cat sudogroups)

  do

    grep %$i /etc/sudoers > /dev/null

    if [ $? -eq 0 ]; then

     echo -n " $i"  >> group.txt
    fi

  done

  echo "  List Of  Sudo Groups        : `cat group.txt | wc -w` (`cat group.txt`) "
 }
 SudoGroups
 Permissions()
 {
   seven=`find / -perm -777 2> /dev/null|wc -l`

   echo "  Number of Files With 777 Permission : "$seven

   four=` find / -perm -4000 2> /dev/null|wc -l`

                  echo "  Number of files with suid bit       :" $four
   echo "  Permission of /etc/passwd file      :" `stat -c " %a " /etc/passwd`
   echo "  Permission of /etc/shadow file      :" `stat -c " %a " /etc/shadow`
 }
 Blank
 Permissions
PasswordExpiry ()

 {

     > champak
    grep -w "/bin/bash" /etc/passwd | grep -vw "root" | cut -d ":"  -f1 > bashusers.txt
    c=0
    for i in $(cat bashusers.txt)

    do

     passage=`grep -w $i /etc/shadow | cut -d ":" -f5`


  if [ $passage -eq 99999 ]; then

      echo -n "$i  "  >> champak

        c=`expr $c + 1`
  fi


   done

     echo "  Users without password expiry       : $c ( `cat champak` )"
  }

   PasswordExpiry
 }

   Tcp_Connection()
{
  echo " Network Connections "
        echo "---------------------"
        count=` netstat --tcp --numeric | grep -v Active | awk '{ print "\t" $5}' | cut -d ":" -f 1 | grep -v Address | wc -l `

        echo "Current Connections (TCP) :" $count
        echo "Connected From Following IPs:"
                       netstat --tcp --numeric | grep -v Active | awk '{ print "\t" $5}' | cut -d ":" -f 1 | grep -v Address

}

 Net_Interface()
{
  echo " NETWORK INFORMATION "

 echo "---------------------"

 PWD=`pwd`

 echo "    MAC Address     :  `ifconfig -a | grep HWaddr | head -1 | tr -s " " | cut -d " " -f5`"
 echo "    Domain          : `hostname -d`"
 value=`cat /etc/sysctl.conf |head -7|tail -1 | tr -s " " |cut -d" " -f 3`

        if [ $value -eq 0 ]; then
        echo "    IP Forwarding   : NO"
        else
        echo "    IP Forwarding   : Yes"

        fi
 service iptables status

 if [ $? -eq 0 ];then
        echo "    Firewall Status : ON"
        else
        echo "    Firewall Status : Off"
        fi
  echo "     "

  echo "  "
  ls  /etc/sysconfig/network-scripts | grep -i ifcfg | grep -v ifcfg-lo | cut -d "-" -f2 > Interface.txt

COUNT=1

 for i in $(cat  Interface.txt)

 do

 cd /etc/sysconfig/network-scripts

 echo "    DEVICE-$COUNT      :"  `grep DEVICE ifcfg-$i | cut -d "=" -f2`

                     dhcp=`cat /etc/sysconfig/network-scripts/ifcfg-$i | head -2 | tail -1 | cut -d "=" -f2`

        if [ "$dhcp" =  none ];then
 echo "    DHCP Enabled  : No"
        else
 echo "    DHCP Enabled   : Yes"
        fi


 echo "    IP-ADDRESS    :"  ` grep IPADDR ifcfg-$i  | cut -d "=" -f2`

 HOST=`grep IPADDR ifcfg-$i  | cut -d "=" -f2`
 echo "    HOSTNAME      :"  `grep $HOST /etc/hosts | awk '{print $2}'`

 echo "    NETMASK       :"  ` grep NETMASK  ifcfg-$i  | cut -d "=" -f2`

 echo "    GATEWAY       :" ` grep ^GATEWAY   ifcfg-$i | cut -d "=" -f2`

 echo "    DNS           :" ` grep DNS    ifcfg-$i | cut -d "=" -f2`
 COUNT=`expr $COUNT + 1`
 echo "-----------------------------------------------------"
 done



        echo "---------------------"
         #nmap --open sql.example.com | grep open
         hostid=`hostname`

 cd /tmp
         nmap --open  $hostid | sed -n '6,15p' | grep -v Nmap  > nmapport

                sed  's/^/  /' nmapport

}

BasicInfo
 Blank
 BasicInfo_2
 Blank
 Top
 CurrentUsers
 Lvm_Info
 Pv_Info
 Blank
 Io_Stat

 Net_Interface
 User_Information
 Tcp_Connection
