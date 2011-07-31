TESTS=$(subst .php,.out,$(wildcard Test*.php))

tests: ${TESTS}

Test%.out:
	echo "Running Test for $*"
	php Test$*.php

