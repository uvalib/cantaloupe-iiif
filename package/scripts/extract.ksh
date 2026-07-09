#
#
#

#set -x

# running on a local dockerd
DOCKER_TOOL=docker

~/Sandboxes/terraform-infrastructure/scripts/ecr-authenticate.ksh

# set the definitions
INSTANCE=cantaloupe-iiif
NAMESPACE=115119339709.dkr.ecr.us-east-1.amazonaws.com/uvalib
TAG=build-20250227123024

IMAGE=${NAMESPACE}/${INSTANCE}:${TAG}

OUTDIR=$(pwd)/distro/lib

# binary
for target in /usr/local/lib/libkdu_a80R.so \
	      /usr/local/lib/libkdu_jni.so \
              /usr/local/lib/libkdu_v80R.so; do
   echo "Extracting ${target}..."
   bn=$(basename $target)
   ${DOCKER_TOOL} run -v ${OUTDIR}:/mnt/mount --rm --entrypoint cp ${IMAGE} ${target} /mnt/mount/${BINDIR}/${bn}
done

echo "Targets available in ${OUTDIR} on the docker host"

#
# end of file
#
