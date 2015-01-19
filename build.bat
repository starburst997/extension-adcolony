rmdir ndll\Android /s /q
cd project
rmdir obj /s /q

lime rebuild . android

REM haxelib run hxcpp Build.xml -Dmac
REM haxelib run hxcpp Build.xml -Dandroid -DHXCPP_ARMV7
REM haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7
REM haxelib run hxcpp Build.xml -Diphonesim