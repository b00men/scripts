server {
	listen       80;
	server_name  www.ta6ypet.co.cc;
	
	# Error pages
	include /etc/nginx/error-pages.conf;

	# Main Dirrectory
	location / {
		root   /var/www/;
		index  index.php index.htm index.html;
    }

	# Php scripts
	location ~ \.php$ {
		fastcgi_pass   127.0.0.1:8888;
		fastcgi_index  index.php;

		fastcgi_param  SCRIPT_FILENAME  /var/www$fastcgi_script_name;
		fastcgi_param  QUERY_STRING     $query_string;
		fastcgi_param  REQUEST_METHOD   $request_method;
		fastcgi_param  CONTENT_TYPE     $content_type;
		fastcgi_param  CONTENT_LENGTH   $content_length;
	}
    
    # Disable .htacces    
	location ~ /\.ht {
		deny  all;
	}
}
