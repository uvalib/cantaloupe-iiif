#
# build the target container
#
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17-al2023-jdk

# update the packages
RUN yum -y update && yum -y install findutils shadow-utils wget unzip hostname

# Create the run user and group
RUN groupadd -g 16339 lb-digiserv && useradd -u 118698 -g lb-digiserv libsnlocal

# set the timezone appropriatly
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Specify home
ENV APP_HOME /cantaloupe-iiif
WORKDIR $APP_HOME

# Create necessary directories
RUN mkdir -p $APP_HOME/scripts $APP_HOME/bin

# Update permissions
RUN chown -R libsnlocal /home/libsnlocal $APP_HOME && chgrp -R lb-digiserv $APP_HOME /home/libsnlocal

# port and run command
EXPOSE 8080
CMD scripts/entry.sh

# add cantaloupe assets
ENV CANTALOUPE_VERSION=5.0.6
RUN cd /tmp && wget https://github.com/cantaloupe-project/cantaloupe/releases/download/v${CANTALOUPE_VERSION}/cantaloupe-${CANTALOUPE_VERSION}.zip && unzip cantaloupe-${CANTALOUPE_VERSION}.zip
RUN cp /tmp/cantaloupe-${CANTALOUPE_VERSION}/cantaloupe-${CANTALOUPE_VERSION}.jar $APP_HOME/bin/cantaloupe.jar
RUN cp /tmp/cantaloupe-${CANTALOUPE_VERSION}/deps/Linux-x86-64/lib/libkdu_a80R.so /tmp/cantaloupe-${CANTALOUPE_VERSION}/deps/Linux-x86-64/lib/libkdu_jni.so /tmp/cantaloupe-${CANTALOUPE_VERSION}/deps/Linux-x86-64/lib/libkdu_v80R.so /usr/local/lib/
RUN rm -fr /tmp/cantaloupe-${CANTALOUPE_VERSION} /tmp/cantaloupe-${CANTALOUPE_VERSION}.zip

# Move in custom assets
COPY package/scripts/entry.sh $APP_HOME/scripts/entry.sh
COPY package/config/cantaloupe.properties $APP_HOME/bin
RUN mkdir -p /home/libsnlocal/.bashrc.d
COPY package/data/container_bash_profile /home/libsnlocal/.bashrc.d/profile
COPY package/src/delegates.rb $APP_HOME/bin

# Ensure permissions are correct
RUN chown libsnlocal:lb-digiserv /home/libsnlocal/.bashrc.d/profile $APP_HOME/scripts/entry.sh && chmod 755 /home/libsnlocal/.bashrc.d/profile $APP_HOME/scripts/entry.sh

# Add the build tag
ARG BUILD_TAG
RUN test -n "$BUILD_TAG" && touch $APP_HOME/buildtag.build-$BUILD_TAG || touch $APP_HOME/buildtag.build-0

# Specify the user
USER libsnlocal

#
# end of file
#
