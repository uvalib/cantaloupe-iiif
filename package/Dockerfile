#
# build the target container
#
FROM public.ecr.aws/amazoncorretto/amazoncorretto:11-al2022-jdk

# update the packages
RUN yum -y update && yum -y install findutils shadow-utils wget unzip

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

# download the cantaloupe release
RUN wget -c https://github.com/cantaloupe-project/cantaloupe/releases/download/v5.0.5/cantaloupe-5.0.5.zip && unzip cantaloupe-5.0.5.zip && rm cantaloupe-5.0.5.zip
RUN mv cantaloupe-5.0.5/cantaloupe-5.0.5.jar $APP_HOME/bin && ln -s $APP_HOME/bin/cantaloupe-5.0.5.jar $APP_HOME/bin/cantaloupe.jar

# Move in openjpeg assets
COPY distro/openjpeg-v2.5.0-linux-x86_64/bin/opj_decompress /usr/local/bin/
COPY distro/openjpeg-v2.5.0-linux-x86_64/bin/opj_dump /usr/local/bin/
COPY distro/openjpeg-v2.5.0-linux-x86_64/lib/libopenjp2.so.7 /usr/local/lib/

# Move in necessary assets
COPY package/scripts/entry.sh $APP_HOME/scripts/entry.sh
COPY package/config/cantaloupe.properties $APP_HOME/bin
COPY package/data/container_bash_profile /home/libsnlocal/.profile
COPY package/src/delegates.rb $APP_HOME/bin

# Ensure permissions are correct
RUN chown libsnlocal:lb-digiserv /home/libsnlocal/.profile $APP_HOME/scripts/entry.sh && chmod 755 /home/libsnlocal/.profile $APP_HOME/scripts/entry.sh

# Add the build tag
ARG BUILD_TAG
RUN test -n "$BUILD_TAG" && touch $APP_HOME/buildtag.build-$BUILD_TAG || touch $APP_HOME/buildtag.build-0

# Specify the user
USER libsnlocal

#
# end of file
#
