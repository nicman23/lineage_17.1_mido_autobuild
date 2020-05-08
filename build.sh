#!/usr/bin/bash
set -e
mkdir lineage &> /dev/null || true
cd lineage

[ ! -e .repo ] && repo init -u https://github.com/LineageOS/android.git -b lineage-17.1
cp -r ../local_manifests .repo/ || cp ../local_manifests/mido.xml .repo/local_manifests/
repo sync -j14 -c --force-sync --no-tags --no-clone-bundle --optimized-fetch --prune

wdir="`pwd`"
for i in ../patches/*
do
  (
    cd "`echo $i | sed -e 's/_/\//g' -e 's/..\/patches\///'`"
    cat "$wdir/$i/"* | patch -p1
  )
done

source build/envsetup.sh
export CCACHE_EXEC=/usr/bin/ccache USE_CCACHE=1 CCACHE_COMPRESS=1
a='lineage_mido-userdebug'; breakfast $a; croot; brunch $a;

cp out/target/product/mido/*UNOFFICIAL-mido.zip .
echo -e '\n\n' created zip *UNOFFICIAL-mido.zip
