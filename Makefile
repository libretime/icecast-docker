icecast:
	git clone --recursive https://gitlab.xiph.org/xiph/icecast-server.git icecast

build: icecast
	docker build . -t icecast
