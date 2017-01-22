wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import - &&

export SWIFT_VERSION_UPPER=swift-3.0.2-RELEASE &&
export SWIFT_VERSION_LOWER=swift-3.0.2-release &&
wget https://swift.org/builds/${SWIFT_VERSION_LOWER}/ubuntu1404/${SWIFT_VERSION_UPPER}/${SWIFT_VERSION_UPPER}-ubuntu14.04.tar.gz &&
tar xzf ${SWIFT_VERSION_UPPER}-ubuntu14.04.tar.gz &&
export PATH=${PWD}/${SWIFT_VERSION_UPPER}-ubuntu14.04/usr/bin:"${PATH}" &&

export PACKAGE_MANAGER_VERSION=swift-DEVELOPMENT-SNAPSHOT-2017-01-20-a &&
wget https://github.com/apple/swift-package-manager/archive/${PACKAGE_MANAGER_VERSION}.tar.gz &&
tar xzf ${PACKAGE_MANAGER_VERSION}.tar.gz &&
export PATH=${PWD}/${PACKAGE_MANAGER_VERSION}/usr/bin:"${PATH}"
