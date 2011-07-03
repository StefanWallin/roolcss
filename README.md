The Project
===========
This project is about setting up an easy to use build environment for javascript, css and html. Letting you get down and start working with your web experiments in a quickie..


Setup
=====

Setup a new project
-------------------
Create a new directory for you project and move to that folder with the terminal.

<pre>
	curl https://raw.github.com/StefanWallin/roolcss/master/Makefile > Makefile
	make setup
</pre>

Setting up git
--------------
<pre>
	make git-setup
</pre>
This command will create some git-ignore rules. <strong style="color:red; font-weight:600;">Be aware! This will wipe out previous .gitignores</strong>

Then do the ordinary procedure of setting up a git repository, presenting yourself, running init and adding a remote. If you have any questions, I recommend reading up on it http://help.github.com/


Updating external libraries
---------------------------
<pre>
	make update-env
</pre>
It's as simple as that!




