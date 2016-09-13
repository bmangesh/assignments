#!/bin/bash
 #Author : Mangesh Bharsakle <mangeshsoft0@gmail.com>
 #Date   : 09/09/2014
 
   ########## COLOUR CODES ##########[DONE]
  
   NONE='\033[00m'
   BOLD='\033[1m'
   RED='\033[01;31m'
   GREEN='\033[01;32m'
   YELLOW='\033[01;33m'
   BLUE='\033[01;34m'
  MAGENTA='\033[01;35m'
  CYAN='\033[01;36m'
 
 #################### START ###################[DONE]
 
  clear
  echo -en ${MAGENTA} ${BOLD}"\t\t\t SERVER REPORT \n"${NONE}
  echo -en ${MAGENTA} ${BOLD}"\t================================================== \n"${NONE}
  echo -en "\n"
 
  ################### DATE ###################[DONE]
 
  m=`date +%B`
  d=`date +%d`
  y=`date +%Y`
  t=`date +%r`
 
  echo -en ${BOLD}"\t Date: ${m} ${d}, ${y} ${t} \t\t\t By: $USER \n\n\n"${NONE}
 
  #################### BASIC SERVER INFORMATION ####################[DONE]
 
  #################### Architecture ####################
  Arch=`arch`
  archi=$(if [ $Arch = "x86_64" ];
  then
  echo "64 Bit"
  else
  echo "32 Bit"
  fi)
 
  echo -en ${MAGENTA} ${BLUE}"\t=============================== \n"${NONE}
  echo -en ${MAGENTA} ${RED}"\t    BASIC SERVER INFORMATION     \n"${NONE}
  echo -en ${MAGENTA} ${BLUE}"\t=============================== \n"${NONE}
  echo -en ${BLUE}"\t IP                 :${NONE}      `ifconfig | grep inet | head -1 | awk -F ' ' '{print $2}'` \n"
  echo -en ${BLUE}"\t Hostname           :${NONE}      `hostname` \n"
  echo -en ${BLUE}"\t OS                 :${NONE}      `uname` \n"
                            
 echo -en ${BLUE}"\t Kernel             :${NONE}      `uname -r |cut -d"." -f1,2,3`\n"
 echo -en ${BLUE}"\t Architecture       :${NONE}      $archi\n"
 ######### TOTAL CPU % ##########[DONE]

  cpuus=`top -n 1|grep Cpu|awk -F ' ' '{print $2}'|awk -F '%' '{print $1}'`
  cpusy=`top -n 1|grep Cpu|awk -F ',' '{print $2}'|awk -F ' ' '{print $2}'`
  cpuni=`top -n 1|grep Cpu|awk -F ',' '{print $3}'|awk -F ' ' '{print $2}'`
  cpuwa=`top -n 1|grep Cpu|awk -F ',' '{print $5}'|awk -F ' ' '{print $2}'`
  cpuhi=`top -n 1|grep Cpu|awk -F ',' '{print $6}'|awk -F ' ' '{print $2}'`
  cpusi=`top -n 1|grep Cpu|awk -F ',' '{print $7}'|awk -F ' ' '{print $2}'`
  cpust=`top -n 1|grep Cpu|awk -F ',' '{print $8}'|awk -F ' ' '{print $2}'`
  cput=$(echo "scale=3; ${cpuus}+${cpusy}+${cpuni}+${cpuwa}+${cpuhi}+${cpusi}+${cpust}" |bc )
 
  echo "$cput"> /tmp/cputot
  tcpu=`cat /tmp/cputot |cut -d '.' -f 1`
 
  ########## TOTAL PHYSICAL MEMORY##########[DONE]
 
  ram=`free -m | grep Mem |awk -F ' ' '{print $3}'`
  ramtotal=`free -m | grep Mem |awk -F ' ' '{print $2}'`
  ram_a=$(echo "scale=3; $ram / $ramtotal"|bc )
  ram_b=$(echo "scale=3; $ram_a * 100"|bc )
  echo "$ram_b">total.txt
 ram_c=`cat total.txt|awk -F '.' ' {print $1}'`
 
  ########## TOTAL SWAP MEMORY ##########[DONE]
 
  swap=`free -m | grep Swap |awk -F ' ' '{print $3}'`
  swaptotal=`free -m | grep Swap |awk -F ' ' '{print $2}'`
  swap_a=$(echo "scale=3; $swap / $swaptotal"|bc )
  swap_b=$(echo "scale=3; $swap_a * 100"|bc )
  echo "$swap_b">totalswap.txt
  swap_c=`cat totalswap.txt|awk -F '.' ' {print $1}'`
 
  ######################################[DONE]
 
  echo -en ${BLUE}"\t Up Time            :${NONE}     `uptime | cut -d ":" -f1` hours `uptime|cut -d ":" -f2` minutes \n"
  echo -en ${BLUE}"\t Current Users      :${NONE}      `who |awk -F ' ' '{print $1}'|uniq|wc -l` \n"
  echo -en ${BLUE}"\t Current processes  :${NONE}      `top -n 1 |grep Tasks|awk -F ' ' '{print $2}'` \n"
  echo -en ${BLUE}"\t CPU Usage          :${NONE}     `if [ $tcpu -le "39" ]; then
                                                      echo -e ${GREEN} ${BOLD}"$cput% ${NONE} ${BLUE}                               ( Threshold 40% , 70% )    "${NONE}
                                                      elif [ $tcpu -ge "40" -a $tcpu -le "69" ]; then
                                                      echo -e ${YELLOW} ${BOLD}"$cput% ${NONE} ${BLUE}                              ( Threshold 40% , 70% )    "${NONE}
                                                      else
                                                      echo -e ${RED} ${BOLD}"$cput% ${NONE} ${BLUE}                                 ( Threshold 40% , 70% )    "${NONE}
                                                      fi `\n"
  echo -en ${BLUE}"\t Memory Usage       :${NONE}    `if [ $ram_c -le 40 ]; then
                                                 echo -e ${GREEN} ${BOLD} "$ram Out of $ramtotal Used [$ram_b % Used]${NONE} ${BLUE} ( Threshold 40% , 70%     )"${NONE}
                                                 elif [ $ram_c -ge 41 -a $ram_c -le 70 ]; then
                                                 echo -e ${YELLOW} ${BOLD} "$ram Out of $ramtotal Used [$ram_b % Used]${NONE} ${BLUE}( Threshold 40% , 70%     )"${NONE}
                                                 else
                                                 echo -e ${RED} ${BOLD} "$ram Out of $ramtotal Used [$ram_b % Used]${NONE} ${BLUE}( Threshold 40% , 70% )"$    {NONE}
                                                 fi`  \n"
  echo -en ${BLUE}"\t Swap Usage         :${NONE}    `if [ $swap_c -le 40 ]; then
                                                echo -e ${GREEN} ${BOLD} "$swap Out of $swaptotal Used [$swap_b% Used]${NONE} ${BLUE}         ( Threshold     40% , 70% )"${NONE}
                                                elif [ $ram_c -ge 41 -a $ram_c -le 70 ]; then
                                                echo -e ${YELLOW} ${BOLD} "$swap Out of $swaptotal Used [$swap_b% Used]${NONE} ${BLUE}        ( Threshold     40% , 70% )"${NONE}
                                                else
                                                echo -e ${RED} ${BOLD} "$swap Out of $swaptotal Used [$swap_b% Used]${NONE} ${BLUE}       ( Threshold 40%     , 70% )"${NONE}
                                                fi`  \n"
 echo -en ${BLUE}"\t System Load        :${NONE}     `top -n 1 |grep "load average" |cut -d ',' -f 3-5|cut -d ':' -f 2|cut -d ',' -f1` ${BLUE}(1 minute),$    {NONE} `top -n 1 |grep "load average" |cut -d ',' -f 3-5|cut -d ':' -f 2|cut -d ',' -f2`${BLUE} (5 minutes),${NONE}`top -n 1 |grep "load average" |cut -d     ',' -f 3-5|cut -d ':' -f 2|cut -d ',' -f1`${BLUE} (15 minutes)${NONE} \n\n\n"


 ##################### PROCESSES LOAD (PROCESSES TAKING HIGHER RESOURCES) ####################

 echo -en ${BLUE} ${BOLD}"\t========================================================= \n"${NONE}
 echo -en ${RED} ${BOLD}"\t    PROCESS LOAD (PROCESSES TAKING HIGHER RESOURCES)     \n"${NONE}
               
 echo -en ${BLUE} ${BOLD}"\t========================================================= \n"${NONE}
 echo -en ${CYAN} ${BOLD}"\t=======================================================================================================\n"${NONE}
 echo -en ${CYAN} ${BOLD}"\t||    USER   ||   PID    ||   %CPU   ||  %MEM  ||                        COMMAND                     ||\n"${NONE}
 echo -en ${CYAN} ${BOLD}"\t=======================================================================================================\n"${NONE}

 ps -eo user,pid,%cpu,%mem,command|sort -k4 -rn|head -10|awk '{printf "\t|| %-10s|| %-9s|| %-9s|| %-7s|| %-50s || \n",$1,$2,$3,$4,$5}'
 echo -en ${CYAN} ${BOLD}"\t=======================================================================================================\n"${NONE}
 echo -en "\n\n\n"

 #################### LIST OF USERS CURRENTLY LOGGED IN (SORTED BY NUMBER OF SESSIONS) ####################

 echo -en "\t${BLUE}========================================================================${NONE}\n"
 echo -en "\t${RED}     List of Users Currently Logged in(sorted by number of sessions)    ${NONE}\n"
 echo -en "\t${BLUE}========================================================================${NONE}\n"


 who|cut -d " " -f1 | sort | uniq -c | while read line
 do
    count=`echo $line | awk -F ' ' '{print $1}'`
    user=`echo $line | awk -F ' ' ' {print $2}'`
    if [ $count -gt 1 ]; then
        echo "$user : $count sessions"
    else
        echo "$user : $count session"
    fi
 done > /var/tmp/user
 cat /var/tmp/user |sort|awk '{printf "\t\t\t %-15s %-1s %-1s %-1s\n",$1,$2,$3,$4}'

 echo -en "\t${BLUE}========================================================================${NONE}\n"
 echo -en "\n\n\n"
 ##################### STORAGE INFORMATION ##################

 echo -en "\t${BLUE}=========================${NONE}\n"
 echo -en "\t${RED}   Storage Information    ${NONE}\n"
 echo -en "\t${BLUE}=========================${NONE}\n\n\n"


 ##################### PARTISION/FILE SYSTEM INFORMATION (THRESHOLD 80% & 85%) ##################

 echo -en "\t${BLUE}==============================================================${NONE}\n"
 echo -en "\t${RED}   Partition/File System Information  (Threshold 80% & 85%)    ${NONE}\n"
 echo -en "\t${BLUE}==============================================================${NONE}\n"

            part=$(fs=`df -h`
 onlyName="false"
 name=""
 echo "$fs" | sed 1d |  while read line
 do
     cl=`echo "$line"|cut -d" " -f2`
     if [ "$cl" == "$line" ] ; then
             onlyName="true"
             name="$line"
             continue
     fi
     if [ "$onlyName" == "true" ]; then
         echo "$name" "$line"
         onlyName="false"
         name=""
         continue
     fi
    echo "$line"
 done | awk '{printf "\t|| %-21s || %10s || %10s || %10s || %10s || %-20s ||\n", $1, $2, $3,$4,$5,$6}')

 echo -en ${CYAN}"\t===========================================================================================================\n"${NONE}
 echo -en ${CYAN}"\t||         NAME          ||    SIZE    ||    USED    ||  AVAILABLE ||    USE%    ||      MOUNTED ON      ||\n"${NONE}
 echo -en ${CYAN}"\t===========================================================================================================\n"${NONE}
 echo -en "$part\n"
 echo -en ${CYAN}"\t===========================================================================================================\n"${NONE}
 echo -en "\n\n\n"

 #################### LVM INFORMATION ####################

 echo -en "\t${BLUE}=====================${NONE}\n"
 echo -en "\t${RED}   LVM Information  ${NONE} \n"
 echo -en "\t${BLUE}=====================${NONE} \n\n"

 ########## LV INFORMATION ##########
 echo -en "\t${BLUE}==============================${NONE}\n"
 echo -en "\t${RED}        LV Information        ${NONE}\n"
 echo -en "\t${BLUE}==============================${NONE}\n"

 lv=$(lvdisplay &>lv.txt
                  while read line
 do
         if echo $line|grep "^LV Name "  >/dev/null
         then
                 lvn=`echo $line |grep "^LV Name"|awk '{printf "\t %-20s\n",$3}'`
                 echo -en "\t|| $lvn || "
         fi
         if echo $line|grep "^VG Name" >/dev/null
         then
                lvg=`echo $line |grep "^VG Name" |awk '{printf " %-15s ", $3}'`
                 echo -n "$lvg    "
                 mount=`cat /etc/mtab|grep $lvg|cut -d" " -f2|awk '{printf " || %-25s",$1}'`
                 echo -n "$mount"
         fi
         if echo $line|grep "^LV Size" >/dev/null
          then
                 lvs=`echo $line|grep "LV Size "|awk -F ' ' '{print $3}'`
                 lvs1=`echo "|| $lvs G ||"|awk '{printf "%-1s %-5s %-10s %-1s",$1,$2,$3,$4}'`
                 echo  "$lvs1   "
         fi
 done<lv.txt)


 echo -en "\t${CYAN}=========================================================================================================${NONE}\n"
 echo -en "\t${CYAN}||            LV              ||          VG           ||        MOUNT POINT       ||       Size       ||${NONE}\n"
 echo -en "\t${CYAN}=========================================================================================================${NONE}\n"
 echo -en "$lv\n"
 echo -en "\t${CYAN}=========================================================================================================${NONE}\n"



 echo -en "\n\n\n"

 ########## PV INFORMATION ##########[DONE]

 echo -en "\t${BLUE}=============================${CYAN}\n"
 echo -en "\t${RED}       PV Information        ${NONE}\n"
 echo -en "\t${BLUE}=============================${NONE}\n"


 pv=$(pvdisplay &> pv.txt
 while read line
 do
         if echo $line|grep "^PV Name "  >/dev/null
         then
                 pvn=`echo $line |grep "^PV Name"|awk '{printf "%-5s",$3}'`
                 echo -en  "\t${CYAN}||${NONE} $pvn      ${CYAN}||${NONE}"
        fi
         if echo $line|grep "^VG Name "  >/dev/null
         then
                 vgn=`echo $line |grep "^VG Name"|awk '{printf "\t %-15s\t", $3}'`
                 echo -n "$vgn${CYAN}||${NONE}    "
         fi
         if echo $line|grep "^PV Size "  >/dev/null
         then
                 pvs=`echo $line |grep "^PV Size"|awk '{printf "%10s",$3,$4}'`
                 echo  "$pvs G  ${CYAN}||${NONE}"
         fi
 done<pv.txt)
 echo -en ${CYAN}"\t======================================================================\n"${NONE}
 echo -en ${CYAN}"\t||      PV        ||             VG             ||        Size      ||\n"${NONE}
 echo -en ${CYAN}"\t======================================================================\n"${NONE}
 echo -en "  $pv \n"
 echo -en ${CYAN}"\t======================================================================\n"${NONE}
 echo -en "\n\n\n"



 #################### I/O STATISTICS ###################

 echo -en "\t${BLUE}====================${NONE}\n"
 echo -en "\t${RED}   I/O Statistics   ${NONE} \n"
 echo -en "\t${BLUE}====================${NONE}\n\n\n"
 echo -en "\t CPU Average I/O wait:`iostat 2 2|sed -n  '/^avg/,~1p'|tail -1|awk '{print $4}'`% \n"
 iostat | sed -n '5,100p'| awk '{printf "\t %-10s %-10s %-10s\n",$1,$3,$4}'
 echo -en "\n\n\n"

 ################### NETWORK INFORMATION ####################

 echo -en "\t${BLUE} =========================${NONE}\n"
 echo -en "\t${RED}    Network Information    ${NONE}\n"
 echo -en "\t${BLUE} =========================${NONE}\n\n"
          ################### INTERFACE INFORMATION ####################

 rm -rf /tmp/interfaceinfo
 eth0=$(raw_interface_data=`ls /etc/sysconfig/network-scripts/|grep "ifcfg"|grep -v "lo"|awk -F '-
 
