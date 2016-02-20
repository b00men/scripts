server {
	listen   80;
	server_name  phpmyadmin.ta6ypet.co.cc;

	# Error pages
	include /etc/nginx/error-pages.conf;

	# Main dirrectory
	location / {
		root /usr/share/phpmyadmin;
		index index.php;
	}

	# Php scripts
	location ~ \.php$ {
		fastcgi_pass   127.0.0.1:8888;
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME  /usr/share/phpmyadmin$fastcgi_script_name;
		fastcgi_param  QUERY_STRING     $query_string;
		fastcgi_param  REQUEST_METHOD   $request_method;
		fastcgi_param  CONTENT_TYPE     $content_type;
		fastcgi_param  CONTENT_LENGTH   $content_length;
	}
}
