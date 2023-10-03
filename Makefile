


Tar_and_export_DB_and_WP_on_server_EPFL:
	ssh wp-prod '( \
	 cd /tmp && \
	 wp db export EPFL_DB_2_AWS.sql --path=/srv/www/www.epfl.ch/htdocs && \
	 tar -czvf epfl2.tar.gz -C /srv/www/www.epfl.ch/htdocs/ wp \
					wp-admin \
					wp-config.php \
					wp-content \
					wp-cron.php \
					wp-includes \
					wp-load.php \
					wp-login.php \
					wp-settings.php \
					.htaccess \
					index.php && \
	tar -czvf wp6.tar.gz /wp && \
	wp db export EPFL_campus_DB_2_AWS.sql --path=/srv/www/www.epfl.ch/htdocs/campus && \
	tar -czvf epfl_camp.tar.gz -C /srv/www/www.epfl.ch/htdocs/campus/ wp \
					wp-admin \
					wp-config.php \
					wp-content \
					wp-cron.php \
					wp-includes \
					wp-load.php \
					wp-login.php \
					wp-settings.php \
					.htaccess \
					index.php)'


send_fils_to_local:
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/srv/www/www.epfl.ch/htdocs/EPFL_DB_2_AWS.sql . && \
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/tmp/epfl2.tar.gz . && \
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/tmp/wp6.tar.gz . && \
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/srv/www/www.epfl.ch/htdocs/campus/EPFL_campus_DB_2_AWS.sql . && \
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/tmp/epfl_camp.tar.gz .



Creation_instance:
	aws ec2 run-instances \
	--region eu-central-1 \
	--image-id ami-0766f68f0b06ab145 \
	--count 1 \
	--instance-type t2.micro \
	--key-name "EPFLWP" \
	--security-group-ids sg-041a0583b9eb05990 \
	--subnet-id subnet-0184f0a9a41ae5092 \
	--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="awsfsdteam3"}]' \
	--user-data file://installation_2_base.txt

Creation_DB:
	aws rds create-db-instance \
  	--db-instance-identifier dbawsfsdteam \
  	--db-instance-class db.t2.micro \
  	--engine mysql \
  	--master-username admin \
  	--master-user-password 12345678 \
	--allocated-storage 20 \


Modification_url:
	cat EPFL_DB_2_AWS.sql | sed 's,https://www.epfl.ch,http://aws.fsd.team,g' > new_db_epfl_aws.sql && \
	tar -xvzf epfl2.tar.gz && \
	cd srv/www/www.epfl.ch/htdocs && \
	cat wp-config.php | sed 's,https://www.epfl.ch,http://aws.fsd.team,g' > new-wp-config.php && \
	cat .htaccess | sed 's,https://www.epfl.ch,http://aws.fsd.team,g' > .newhtaccess && \
	rm wp-config.php && \
	mv .newhtaccess .htaccess && \
	mv new-wp-config.php wp-config.php && \
	cd ~ && \
	tar -czvf new_epfl2.tar.gz /Users/dorer/srv
	
Creation_IP_fix:
	aws ec2 allocate-address && \
	aws ec2 associate-address --instance-id i-0462f7f8c2b23872d --public-ip 18.159.193.60

Send_fils_to_AWS:
	scp new_epfl2.tar.gz ec2-user@18.159.193.59:/home/ec2-user && \
	scp wp6.tar.gz ec2-user@18.159.193.59:/home/ec2-user && \
	scp Makefiles ec2-user@18.159.193.59:/home/ec2-user && \
	ssh ec2-user@18.159.193.59 '(\
		sudo mv new_epfl2.tar.gz /var/www/html && \
		sudo mv wp6.tar.gz. /var/www/html && \
		sudo mv epfl_camp.tar.gz /var/www/html )'


Connection_AWS:
	ssh ec2@aws.fsd.team



	
recupération_DB_PASSWORD:
	DB_PASSWORD=$(cat wp-config.php | grep DB_PASSWORD | grep -o "'[^']*'" | awk 'NR==2 {gsub(/'\''/, "", $0); print}')
	
recupération_DB_NAME:
	DB_NAME=$(cat wp-config.php | grep DB_NAME | grep -o "'[^']*'" | awk 'NR==2 {gsub(/'\''/, "", $0); print}')
	
recupération_DB_USER:
	DB_USER=$(cat wp-config.php | grep DB_USER | grep -o "'[^']*'" | awk 'NR==2 {gsub(/'\''/, "", $0); print}')
	
Creation_User_et_import:

	CREATE USER $DB_NAME@'%' IDENTIFIED BY $DB_PASSWORD; && \
	ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO $DB_NAME@'%' WITH GRANT OPTION; && \
	Create database $DB_NAME;
	SOURCE new_db_epfl_aws.sql;

Plugin_move:
	sudo mv accred .. && \
	sudo mv polylang .. && \
	sudo mv tequila ..
