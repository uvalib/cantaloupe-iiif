#
# startup script
#

export LD_LIBRARY_PATH=/usr/local/lib
cd bin; java -Dcantaloupe.config=cantaloupe.properties ${JAVA_OPTS} -jar cantaloupe.jar

#
# end of file
#
