TOPDIR=.
NODEPATH=${TOPDIR}/lib/node-latest-install

install:
	echo "Building"
	
update-env:
	curl https://raw.github.com/cloudhead/less.js/master/bin/lessc > ${TOPDIR}/lib/lessc
	rm -rf ${NODEPATH}; mkdir -p ${NODEPATH}
	cd ${NODEPATH}
	curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
	./configure --prefix=${NODEPATH}
	make install # ok, fine, this step probably takes more than 30 seconds...
	curl http://npmjs.org/install.sh | sh
	
setup-env:
	echo "export PATH=${NODEPATH}:${PATH}" >> ~/.bashrc
	source ~/.bashrc
	export lib="`ls -l|grep lib|wc -l`"
	[${lib} -ne 1 ] && echo "Skapar Mapp"; mkdir -p ${TOPDIR}/lib/
	make update-env
	
