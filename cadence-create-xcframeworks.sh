ROOT="./.build/xcframeworks"

rm -rf $ROOT

for SDK in iphoneos iphonesimulator
do
xcodebuild archive \
    -scheme Nuke \
    -archivePath "$ROOT/nuke-$SDK.xcarchive" \
    -sdk $SDK \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    DEBUG_INFORMATION_FORMAT=DWARF
done

xcodebuild -create-xcframework \
    -framework "$ROOT/nuke-iphoneos.xcarchive/Products/Library/Frameworks/Nuke.framework" \
    -framework "$ROOT/nuke-iphonesimulator.xcarchive/Products/Library/Frameworks/Nuke.framework" \
    -output "$ROOT/Nuke.xcframework"

cd $ROOT
zip -r -X nuke-xcframeworks-ios.zip *.xcframework
rm -rf *.xcframework
cd -

for SDK in iphoneos iphonesimulator
do
xcodebuild archive \
    -scheme NukeExtensions \
    -archivePath "$ROOT/nuke-extensions-$SDK.xcarchive" \
    -sdk $SDK \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    DEBUG_INFORMATION_FORMAT=DWARF
done

xcodebuild -create-xcframework \
    -framework "$ROOT/nuke-extensions-iphoneos.xcarchive/Products/Library/Frameworks/NukeExtensions.framework" \
    -framework "$ROOT/nuke-extensions-iphonesimulator.xcarchive/Products/Library/Frameworks/NukeExtensions.framework" \
    -output "$ROOT/NukeExtensions.xcframework"

cd $ROOT
zip -r -X nuke-extensions-xcframeworks-ios.zip *.xcframework
rm -rf *.xcframework
cd -

mv $ROOT/*.zip ./
