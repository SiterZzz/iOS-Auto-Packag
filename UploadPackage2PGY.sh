

#工程名称
scheme_name="圈子店"

# 返回上一级目录,进入项目工程目录
cd /Users/stw/Desktop/v1732
# 获取项目名称
project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`

archive_path="/Users/stw/Desktop/auto-package/Project.xcarchive"

api_path="/Users/stw/Desktop/auto-package/ipa_File"

export_path="/Users/stw/Desktop/auto-package/ExportOptions.plist"

# 清理工程
xcodebuild -workspace ${project_name}.xcworkspace -scheme ${scheme_name} -configuration Release clean

# 构建 .xcarchive 文件
xcodebuild archive -workspace ${project_name}.xcworkspace -scheme ${scheme_name} -configuration Release -archivePath $archive_path

# 通过 .xcarchive 文件 导出 .ipa 的包
xcodebuild -exportArchive -archivePath  $archive_path -exportPath $api_path -exportOptionsPlist $export_path

# 将 .ipa 的包上传至蒲公英平台
curl -F "file=@$api_path/$scheme_name.ipa" \
-F "uKey=xxx" \
-F "_api_key=xxx" \
-F "updateDescription=$1" \
https://www.pgyer.com/apiv1/app/upload

# 删除多余文件
rm -r -f $archive_path
rm -r -f $api_path
