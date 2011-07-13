#root dir
TOPDIR=$(realpath .)

#libs
LIBDIRNAME=lib
LIBS=${TOPDIR}/${LIBDIRNAME}
NODEPATH=${LIBS}/node
LESSPATH=${LIBS}/less
JSLINTPATH=${LIBS}/js-lint
CSSLINTPATH=${LIBS}/css-lint
CSSVALIDATORPATH=${LIBS}/css-validator
HTMLVALIDATORPATH=${LIBS}/html-validator
COMPASSPATH=${LIBS}/compass

BUILDDIR=${TOPDIR}/build
RESOURCEDIR_B=
		#If non-empty, remember intial slash!

SOURCEDIR=${TOPDIR}/src
RESOURCEDIR_S=/r
		#If non-empty, remember intial slash!

CSSDIR=css
JSDIR=js
IMGDIR=img
OBJDIR=obj
SPRITEDIR=sprites


#TODO:
# * Test for installed node
# * Test for installed python
# * Test for installed git
# * Test for installed hg (mercurial)
# * Test for JAVA_HOME


#Special targets:
.SILENT:	help
.SILENT:	debug
.SILENT:	setup-git
	
default: help


debug:
	echo "VARS:"
	echo "====="
	echo "libdirname: 		${LIBDIRNAME}"
	echo "libs: 			${LIBS}"
	echo "nodepath:		${NODEPATH}"
	echo "lesspath:		${LESSPATH}"
	echo "jslintpath:		${JSLINTPATH}"
	echo "csslintpath:		${CSSLINTPATH}"
	echo "cssvalidatorpath: 	${CSSVALIDATORPATH}"
	echo "htmlvalidatorpath:	${HTMLVALIDATORPATH}"
	echo "compasspath: 		${COMPASSPATH}"
	echo ""
	echo "builddir: 		${BUILDDIR}"
	echo "resourcedir_b: 	${RESOURCEDIR_B}"
	echo "sourcedir: 		${SOURCEDIR}"
	echo "resourcedir_s:		${RESOURCEDIR_S}"
	echo ""
	echo "cssdir:			${CSSDIR}"
	echo "jsdir: 			${JSDIR}"
	echo "imgdir:			${IMGDIR}"
	echo "objdir:			${OBJDIR}"
	echo "sprites:"		${SPRITEDIR}

##########################
# Setup part of makefile #
##########################

install:
	echo "Building"
update-env:
	echo " :: Updating libraries."
	make -s install-node
	make -s install-npm
	make -s install-less
	make -s install-css-validator
	make -s install-html-validator
	make -s install-js-lint
	make -s install-css-lint
	make -s install-compass
	
install-node:
	echo " :: Removing old node-server"
	rm -rf ${NODEPATH}; mkdir -p ${NODEPATH}
	rm -rf node; mkdir -p node
	echo " :: Downloading nodejs."
	curl -s http://nodejs.org/dist/node-latest.tar.gz > node-latest.tar.gz 
	
	echo " :: Unzipping nodejs."
	
	tar xzf node-latest.tar.gz --strip-components=1 -C node
	
	echo " :: Configuring nodejs."
	cd node; ./configure --prefix=${NODEPATH}
	
	echo " :: Installing nodejs."
	cd node; make -s install
	
	echo " :: Removing tarball and source dir."
	rm -rf node-latest.tar.gz node

	echo " :: Node installation done."	
install-npm:

	echo " :: Removing old npm(node package manager)."
	

	echo " :: Downloading npm."
	curl http://npmjs.org/install.sh > npm-install.sh	

	echo " :: Installning npm."
	chmod +x npm-install.sh
	export PATH=${NODEPATH}/bin:${PATH};./npm-install.sh

	rm npm-install.sh
	echo " :: npm installation done."

install-less:
	echo " :: Removing old less css compiler"
	rm -rf ${LESSPATH}; mkdir -p ${LESSPATH}
	
	echo " :: Downloading lessc, the commandline less css compiler."
	curl -s https://raw.github.com/cloudhead/less.js/master/bin/lessc > ${LESSPATH}/lessc.js
	
	echo " :: less compiler installation done."	
install-css-validator:
	echo " :: Removing old CSS Validator"
	rm -rf ${CSSVALIDATORPATH}; mkdir -p ${CSSVALIDATORPATH}
	
	echo " :: Setting up the Jigsaw CSS Validator"
	cd ${CSSVALIDATORPATH}; git clone git://github.com/StefanWallin/jigsaw-runner.git
	cd ${CSSVALIDATORPATH}/jigsaw-runner/; sh jigsaw-update.sh
	echo " :: CSS Validator installation done."
	
install-html-validator:
	#info:	http://about.validator.nu/#src
	echo " :: Removing old HTML Validator"
	rm -rf ${HTMLVALIDATORPATH}; mkdir -p ${HTMLVALIDATORPATH}
	cd ${HTMLVALIDATORPATH};	hg clone https://bitbucket.org/validator/build build
	export JAVA_HOME="/Library/Java/Home/"; cd ${HTMLVALIDATORPATH}; python build/build.py all
	export JAVA_HOME="/Library/Java/Home/"; cd ${HTMLVALIDATORPATH}; python build/build.py all
	#Duplicate line is not a typo, it resolves a  ClassCastException-bug.
	
install-js-lint:
	echo " :: Removing old JSLinter"
	rm -rf ${JSLINTPATH}; mkdir -p ${JSLINTPATH}

install-css-lint:
	echo " :: Removing old CSSLinter"
	rm -rf ${CSSLINTPATH}; mkdir -p ${CSSLINTPATH}
	
install-compass:
	echo " :: Removing old Compass"
	rm -rf ${COMPASSPATH}; mkdir -p ${COMPASSPATH}

setup-env:
	
	echo " :: Setting up environment variables"
	mkdir -p ${NODEPATH}
	# export PATH=${NODEPATH}/bin:${PATH}
	# export JAVA_HOME="/Library/Java/Home/"
	echo "export PATH='${NODEPATH}/bin:${PATH}'" >> ~/.bash_profile
	echo 'export JAVA_HOME="/Library/Java/Home/"' >> ~/.bash_profile
	source ~/.bash_profile #Don't seem to work... :(
	
	echo " :: Creating lib folder."; 
	mkdir -p ${LIBS}
	
	echo " :: Downloading and installing libraries..."
	make -s update-env
	echo " :: Done downloading and installing libraries."

	echo " :: Setting up build directories."
	mkdir -p ${BUILDDIR}
	mkdir -p ${BUILDDIR}${RESOURCEDIR_B}/${CSSDIR}
	mkdir -p ${BUILDDIR}${RESOURCEDIR_B}/${JSDIR}
	mkdir -p ${BUILDDIR}${RESOURCEDIR_B}/${IMGDIR}
	mkdir -p ${BUILDDIR}${RESOURCEDIR_B}/${OBJDIR}	

	echo " :: Setting up source directories."
	mkdir -p ${SOURCEDIR}
	mkdir -p ${SOURCEDIR}${RESOURCEDIR_S}/${CSSDIR}
	mkdir -p ${SOURCEDIR}${RESOURCEDIR_S}/${JSDIR}
	mkdir -p ${SOURCEDIR}${RESOURCEDIR_S}/${IMGDIR}
	mkdir -p ${SOURCEDIR}${RESOURCEDIR_S}/${OBJDIR}
	mkdir -p ${SOURCEDIR}${RESOURCEDIR_S}/${SPRITEDIR}
	
	echo " ::"	
	echo " :: The environment is set up. Now point your webserver towards:"
	echo " ::	${BUILDDIR}"
	echo " ::"
	echo " :: To set up version management with git, run this command: "
	echo " ::	make setup-git"
	echo " ::"
	echo " :: For additional usage, see https://github.com/StefanWallin/roolcss/"

setup-git:
	touch .gitignore
	echo ${NODEPATH} > .gitignore
	echo ${LESSPATH} > .gitignore

	echo ".gitignore is set up. Now continue to http://help.github.com/ and set up a new repository, namely this."

setup:
	make -s setup-env

##########################
# Usage part of makefile #
##########################


help:
	echo "Available targets:"
	echo "=================="
	echo " "
	echo "help			Displays this information"
	echo "setup-env		Set up the staging environment."
	echo "setup-git		Set up the git ignore rules."
	echo "update-env		Updates the third party libraries to build this project."
	echo " "
	echo "ir			Builds and installs all resources."
	echo "ic			Builds and installs the css & less resources."
	echo "ij			Builds and installs the javascript."
	echo "ip			Builds and installs the image resources."
	echo "is			Builds and installs all the sprites."
	echo "io			Builds and installs all the object resources."
	echo " "
	echo "test			Run all available test methods."
	echo "jslint		 	Run all the javascript tests."
	echo "csslint			Run all the css tests."
	echo "htmllint		Run all the markup tests."


ir:
	#Builds and installs all resources.
	make ic ij ip is io
	
ic:
	#Builds and installs the css & less resources.
	
ij:
	#Builds and installs the javascript.
	
ip:
	#Builds and installs the image resources.
	
is:
	#Builds and installs all the sprites.
	
io:
	#Builds and installs all the object resources.
 
test:
	#Run all available test methods.
	make jslint csslint htmllint
	
jslint:
	#Run all the javascript tests.
	
csslint:
	#Run all the css tests.
	
htmllint:
	#Run all the markup tests.
