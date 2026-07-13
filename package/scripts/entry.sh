#!/usr/bin/env bash
#
# run application
#

export LD_LIBRARY_PATH=/usr/local/lib
cd bin; java -Dcantaloupe.config=cantaloupe.properties ${JAVA_OPTS} -jar cantaloupe.jar

# return the status
exit $?

#
# end of file
#
