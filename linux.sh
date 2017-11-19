mkdir .sources &&
find Sources -name '*.swift' -exec mv {} .sources \; &&
rm -rf Sources &&
mkdir Sources &&
mv .sources/*.swift Sources &&
rm -rf .sources &&
mkdir .tests &&
mv *Tests .tests &&
mv .tests Tests &&
mv LinuxMain.swift Tests