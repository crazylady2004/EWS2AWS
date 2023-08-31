ssh:
	ssh wp-prod '( \
	 cd /tmp && \
	 wp db export EPFL_DB_2_AWS.sql --path=/srv/www/www.epfl.ch/htdocs && \
	 tar -czvf epfl2.tar.gz 	/srv/www/www.epfl.ch/htdocs/wp \
					/srv/www/www.epfl.ch/htdocs/wp-admin \
					/srv/www/www.epfl.ch/htdocs/wp-config.php \
					/srv/www/www.epfl.ch/htdocs/wp-content \
					/srv/www/www.epfl.ch/htdocs/wp-cron.php \
					/srv/www/www.epfl.ch/htdocs/wp-includes \
					/srv/www/www.epfl.ch/htdocs/wp-load.php \
					/srv/www/www.epfl.ch/htdocs/wp-login.php \
					/srv/www/www.epfl.ch/htdocs/wp-settings.php \
					/srv/www/www.epfl.ch/htdocs/index.php && \
	tar -czvf wp6.tar.gz /wp && \
	wp db export EPFL_campus_DB_2_AWS.sql --path=/srv/www/www.epfl.ch/htdocs/campus && \
	tar -czvf epfl_camp.tar.gz 	/srv/www/www.epfl.ch/htdocs/campus/wp \
					/srv/www/www.epfl.ch/htdocs/campus/wp-admin \
					/srv/www/www.epfl.ch/htdocs/campus/wp-config.php \
					/srv/www/www.epfl.ch/htdocs/campus/wp-content \
					/srv/www/www.epfl.ch/htdocs/campus/wp-cron.php \
					/srv/www/www.epfl.ch/htdocs/campus/wp-includes \
					/srv/www/www.epfl.ch/htdocs/campus/wp-load.php \
					/srv/www/www.epfl.ch/htdocs/campus/wp-login.php \
					/srv/www/www.epfl.ch/htdocs/campus/wp-settings.php \
					/srv/www/www.epfl.ch/htdocs/campus/index.php)'




copie:
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/srv/www/www.epfl.ch/htdocs/EPFL_DB_2_AWS.sql . && \
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/tmp/epfl2.tar.gz . && \
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/tmp/wp6.tar.gz . && \
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/srv/www/www.epfl.ch/htdocs/campus/EPFL_campus_DB_2_AWS.sql . && \
	scp -P 32222 www-data@ssh-wwp.epfl.ch:/tmp/epfl_camp.tar.gz .





instance:
	aws ec2 run-instances \
	--region eu-central-1 \
	--image-id ami-0766f68f0b06ab145 \
	--count 1 \
	--instance-type t2.micro \
	--key-name "EPFLWP" \
	--security-group-ids sg-047ff554f42b5c778 \
	--subnet-id subnet-0184f0a9a41ae5092 \
	--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=servtest2}]'\
	--user-data file://my_script.txt

