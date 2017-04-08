#!/bin/bash

# radarr base volume
RADARR_CONFIG_DIR='/volumes/config/radarr'
# number of previous releases to keep in download directory
RADARR_NUM=2

WGET=$(which wget)
MONO=$(which mono)


# check if radarr release directory is present
if [ ! -d ${RADARR_CONFIG_DIR}/releases ]; then
  echo "[INFO] Creating directory to store radarr releases (${RADARR_CONFIG_DIR}/releases)"
  mkdir ${RADARR_CONFIG_DIR}/releases
fi

# grab latest release version of radarr
RADARR_VERSION=$( $WGET --quiet                                                \
                        --output-document                                      \
                        - https://api.github.com/repos/Radarr/Radarr/releases |\
                  sed --quiet "s/^.*tag_name.*: \"v\(.*\)\".*/\1/p"           |\
                  head -1
                )

# check if release has already been downloaded
if [ ! -f ${RADARR_CONFIG_DIR}/releases/radarr-${RADARR_VERSION}.tar.gz ]; then
  echo "[INFO] Downloading radarr release v${RADARR_VERSION}"
  # download radarr
  $WGET --output-document ${RADARR_CONFIG_DIR}/releases/radarr-${RADARR_VERSION}.tar.gz \
        --quiet                                                                         \
        https://github.com/Radarr/Radarr/releases/download/v${RADARR_VERSION}/Radarr.develop.${RADARR_VERSION}.linux.tar.gz
else
  echo "[INFO] Found radarr release v${RADARR_VERSION} local."
fi

# extract / install radarr
echo "[INFO] Installing radarr"
if [ ! -d /opt/radarr ]; then
  mkdir /opt/radarr
fi
tar --extract                                                             \
    --gunzip                                                              \
    --file /${RADARR_CONFIG_DIR}/releases/radarr-${RADARR_VERSION}.tar.gz \
    --directory /opt/radarr                                               \
    --strip-components=1

# prune old builds
echo "[INFO] Pruning old radarr builds"
i=0
for BUILD in $(find ${RADARR_CONFIG_DIR}/releases -name radarr*.tar.gz -print0| xargs -0 ls -t); do
  # is counter greater than number of builds to keep?
  if [ $i -gt ${RADARR_NUM} ]; then
    rm -f $BUILD
  fi
  # increase counter
  let i+=1
done

$MONO /opt/radarr/Radarr.exe --no-browser -data=${RADARR_CONFIG_DIR}
