#! /bin/bash
#Author : Mangesh Bharsakle <mangeshsoft0@gmail.com>
#Date   :12-10-2014

#Make Sure Only Root User Can run This Shell Script

if [ `whoami` = 'root' ]; then

    echo "  You can Run This Script "
   
    echo "  Checking Required Packages"

    Req_Pack ( )
    {

      rpm -q httpd mysql-server php php-mysql  > /dev/null
 
      if [ $? -eq 0 ]; then

         echo "  All Required Packages are Install.."

      else

         rpm -q httpd > /dev/null
           if [ $? -ne 0 ]; then
             echo "  Need To Install Httpd Package"
             
	     echo "  Installing Httpd Package.."
 	     
	     yum install httpd -y >> /dev/null 2> /dev/null

                 if [ $? -ne 0 ]; then

	            echo "  Error In Httpd Installation.."
                    exit 9
                 fi
            fi

           rpm -q mysql-server > /dev/null
           if [ $? -ne 0 ]; then
             echo "Need To Install mysql-server Package"

             echo "Installing mysql-server Package.."

             yum install mysql-server -y >> /dev/null 2> /dev/null

                 if [ $? -ne 0 ]; then

                    echo "Error In mysql-server Installation.."
                    exit 9
                 else
                   
                  echo  "  Please Give Your Precious Minute to Configure MYSQL-SERVER "
                  
                  service mysqld restart

                  /usr/bin/mysql_secure_installation

                  echo " Thanks For Giving Your Time,Please Remember mysql-server Password"
                 fi

           fi

             rpm -q php > /dev/null
           if [ $? -ne 0 ]; then
             echo "Need To Install PHP Package"

             echo "Installing PHP Package.."

             yum install php -y >> /dev/null 2> /dev/null

                 if [ $? -ne 0 ]; then

                    echo "Error In php Installation.."
                    exit 9
                 else
	     
                   echo " Php Installed Successfully "
                 fi

            fi

              rpm -q php-mysql > /dev/null
           if [ $? -ne 0 ]; then
             echo "Need To Install php-mysql Package"

             echo "Installing php-mysql Package.."

             yum install php-mysql -y >> /dev/null 2> /dev/null

                 if [ $? -ne 0 ]; then

                    echo "Error In php-mysql Installation.."
                    exit 9         #Exit Status (Shell Script Fail Due to Error In Package Installation)
                 else
                 echo "  Php-mysql Installed Successfully"
                 fi
 
           fi         
             

           
     fi
    }
  Req_Pack    

   #Aksing For Doamin Name  from User
  
   read -p "  Please Enter Doamin Name e.g abc.com  " domain

   echo "127.0.0.1  $domain" >> /etc/hosts    #Localhost 127.0.0.1

   echo -e "  Host added to /etc/hosts File \n"


  # Create Domain Name Directory In /var/www as Document Root for exampel.com Host

  mkdir /var/www/html/$domain

  # Downloading WorldPress

   echo " Please Wait Wordpress is Downloading .."

    
    wget https://wordpress.org/latest.tar.gz --no-check-certificate

   if [ $? -ne 0 ]; then

       echo "  Error In Dowloading WorldPress"

       exit -20   ##Exit status -20 Downloading Fail
   fi
      tar -xzvf latest.tar.gz  -C  /var/www/html/$domain  
   
  #Assuming mysql-server is Pre_Configured
  #Do you want to add New User or Continue with Root User
  #Asking User to Enter mysql-server user-name and password

  read -p "  Enter mysql-server root Password " password

  ### Check mysql-server Authentication
  echo "system whoami" | mysql -u root -p$password > /dev/null 2> /dev/null 
  if [ $? -ne 0 ]; then

    echo "  Authentication failed on connection to the mysql-server!!"

    exit -10

  fi
 
  read -p "  Enter  Database Name "   datab

  echo "CREATE DATABASE $datab;" | mysql -u root -p$password



  if [ $? -eq 0 ]; then

     echo "  Database Created Successfully"
  else
    echo "  Error In Creating Database"

  fi


  WP_Configuration ( )

  {

    # create config file
    if [ -f /var/www/html/$domain/wordpress/wp-config-sample.php ]; then
 
    cp -r /var/www/html/$domain/wordpress/wp-config-sample.php /var/www/html/$domain/wordpress/wp-config.php

    fi
        sed -i -r "s/define\('DB_NAME', '[^']+'\);/define\('DB_NAME', '$datab'\);/g" /var/www/html/$domain/wordpress/wp-config.php
        sed -i -r "s/define\('DB_USER', '[^']+'\);/define\('DB_USER', 'root'\);/g" /var/www/html/$domain/wordpress/wp-config.php
        sed -i -r "s/define\('DB_PASSWORD', '[^']+'\);/define\('DB_PASSWORD', 'redhat'\);/g" /var/www/html/$domain/wordpress/wp-config.php
  }

  Virtual_Host ( )
 {


echo "
 <VirtualHost 127.0.0.1:80>
    ServerAdmin root@$domain
    DocumentRoot /var/www/html/$domain
    DirectoryIndex index.html
    ServerName $domain
    ErrorLog logs/dummy-host.$domain-error_log
    CustomLog logs/dummy-host.$domain-access_log common
  <Directory />
     AllowOverride All
  </Directory>
 
 </VirtualHost>
 " >> /etc/httpd/conf/httpd.conf

   httpd -t > /dev/null 2> /dev/null
   if [ $? -eq 0 ]; then

   echo  "  New Virtual Host Added"

   else

   echo  "  Failed to Add new Virtual Host"
  
  ### restart apache 
  service httpd restart >> /dev/null

  fi 

 }
 Virtual_Host   ## Invoking Virtual Host Function
   
 WP_Configuration ## Invoking Virtual Host Function

 Test ( )

 {
   
  touch /var/www/html/$domain/index.html   ### Create index.html file for testing wordpress installation
  
  echo "<html>
        <head><title>Welcome Page..</title></head>
        <body>
        <H3> To Test wordpress installation , Please CLick below Link
        <H3><a href="http://127.0.0.1/wordpress/wp-admin/install.php/">Click Here</a>
        </body>
        </html>" >> /var/www/html/$domain/index.html
   
   }

  Test
 ### restart mysql-server
 service httpd restart > /dev/null
 service mysqld restart  > /dev/null


 echo "  You Can Test Wordpress Deployment at http://$domain/wordpress/wp-admin/about.php/"
  
 
else

    echo "You Must Be Root User to Run This Script"
    exit 1          #Exit Status (Shell Script Fail Due To Unauthorized User)
fi
