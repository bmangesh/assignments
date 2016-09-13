#! /bin/bash
# Aim    : This Script is mainly written to take a backup of User's Home Directory
# Author : MANGESHKUMAR B BHARSAKLE
# 1: userslist.txt root@192.168.0.24 /var/tmp/backup  root@desktop24.example.com 7

  if [ $# -ne 4 -a $# -ne 5 ]; then
      echo "cla msg"
      exit 9
  fi

        if [ ! -e $1 ]; then
           echo " File Does not Exits "
           exit 9
        else
                if [ ! -s $1 ]; then
                    echo " Empty File "
                    exit 9
                fi
        fi
        error=/home/mangeshk/Bin/log/errorlog.txt
        send=~/Bin/log/usermail.txt
        IP=`echo $2 | cut -d "@" -f 2`
        ping -c1  $IP  &> $error

            if [ $? -eq 0 ]; then

                   ssh $2 "cd $3" &> $error

                        if [ $? -eq 0 ]; then

                                         echo "========================Valid User Details=====================" >  /home/mangeshk/Bin/log/validusers.txt
                                         echo "========================Invalid User Details===================" >  /home/mangeshk/Bin/log/invalidusers.txt
                                         echo "===============Unsufficient Permission on  Home Directory==========" >  /home/mangeshk/Bin/log/permission.txt
                                         touch  /home/mangeshk/Bin/log/star.txt
                                         echo  "=====================Time Detail's=================================" > /home/mangeshk/Bin/log/star.txt
                                         echo "Backup Start Time `(date +%X)`" >> /home/mangeshk/Bin/log/star.txt
                                        for i in $(cat $1)
                                        do
                                        found=`grep -w $i /etc/passwd | cut -d ":" -f 6`
                                        if [ ! "$found" = "" ]; then
                                        # echo "========================Valid User Details=====================" >>  /home/mangeshk/Bin/log/validusers.txt
                           
  echo "========================Invalid User Details===================" >  /home/mangeshk/Bin/log/invalidusers.txt
                                         echo "===============Unsufficient Permission on  Home Directory==========" >  /home/mangeshk/Bin/log/permission.txt
                                         touch  /home/mangeshk/Bin/log/star.txt
                                         echo  "=====================Time Detail's=================================" > /home/mangeshk/Bin/log/star.txt
                                         echo "Backup Start Time `(date +%X)`" >> /home/mangeshk/Bin/log/star.txt
                                        for i in $(cat $1)
                                        do
                                        found=`grep -w $i /etc/passwd | cut -d ":" -f 6`
                                        if [ ! "$found" = "" ]; then
                                        # echo "========================Valid User Details=====================" >>  /home/mangeshk/Bin/log/validusers.txt
                                        echo "$i" >> /home/mangeshk/Bin/log/validusers.txt
                                        echo "$i  $found"
                                if [ -x $found -a -r $found ]; then
                                        echo "Yes You Can Take Backup of Dir $found"
                                        echo "=========================================================" > $send
                                        echo "================= Server Report ==========================" >> $send
                                        echo "   Date                   : `(date +%x)`   `(date +%T)`" >> $send
                                        echo "   Prepared By            : `whoami` " >> $send
                                        echo "   Backup Started On      : `(date +%X)` " >> $send
                                        tar jcf - $found 2> $error | ssh $2 "cat > $3/backup-$i-`(date --iso)`.tar.gz"
                                #  =============================================================================

                                # if [ "$5" = "" ]; then

                                  #    ssh $2 "find $3 -name '*.tar.gz' -mtime +7 -delete"
                        #       else
                        #                ssh $2 "find $3 -name '*.tar.gz' -mtime +$5 -delete"
                        #       fi
                                #  =============================================================================
                                        echo "   Backup Finished On     : `(date +%X)`" >> $send
                                        echo "   Backup File Detail     : backup-$i-`(date --iso)`.tar.gz" >> $send
                                        a=`du -sh $found`
                                        a=`echo $a | cut -d " " -f1`
                                        echo "   Original Backup Size   : $a " >> $send

                                        #da=(date --iso)
                                        output=`ssh $2 "du -sh  $3/backup-$i-$(date --iso).tar.gz"`
                                        #echo "$output"
                                        output=`echo $output | cut -d " " -f1`
                                        #echo $utput | cut -d " " -f1
                                        echo "   Compressed Backup Size : $output" >> $send
                                        echo "===========================================================" >> $send
                                        echo "=================== Server Report End =======================" >> $send
                                        mail -s "backup Successfull" $i < $send
                                        #mail -s "Backup Report" $4 < $error
                                                     else
                                                echo "Dear User ,Your Home Dir  Will not be Backup  Until It Has Read " > $send
                                                echo "And Execute Permission , please follow this command to set permission" >> $send
                                                echo "setfacl -m u:mangeshk:rx $found" >> $send
                                                mail -s "Backup Unsuccessfull" $i < $send
                                                echo "$i" >>  /home/mangeshk/Bin/log/permission.txt
                                        fi
                                        else
                                        echo "User $i does not exit"
                                        echo "$i" >> /home/mangeshk/Bin/log/invalidusers.txt
                                        fi
                                        done

#=====================================================================================================================

                                 echo "Backup Ending Time `(date +%X)`" >> /home/mangeshk/Bin/log/star.txt
                                if [ "$5" = "" ]; then

                                      ssh $2 "find $3 -name '*.tar.gz' -mtime +7 -delete"
                                else
                                         ssh $2 "find $3 -name '*.tar.gz' -mtime +$5 -delete"
                                fi
    cat /home/mangeshk/Bin/log/invalidusers.txt /home/mangeshk/Bin/log/validusers.txt /home/mangeshk/Bin/log/permission.txt /home/mangeshk/Bin/log/star.txt >  /home/mangeshk/Bin/log/logs

                    cat /home/mangeshk/Bin/log/logs | mail -s "Final report" $4

#======================================================================================================================


                          else
                                  echo "check Remort Server Dir "


                        fi
                 else

                 echo "Network Unreachable"
             fi
