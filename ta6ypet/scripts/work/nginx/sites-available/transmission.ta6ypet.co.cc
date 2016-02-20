server {
	listen   80;
	server_name  transmission.ta6ypet.co.cc;

	# Error pages
	include /etc/nginx/error-pages.conf;

	# Main trap
	location /transmission {
		proxy_pass	http://127.0.0.1:9091/transmission;
	}

	# Main directory
	location / {
		proxy_pass	http://127.0.0.1:9091/transmission/web/;
	}
}
