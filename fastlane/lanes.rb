# global vars
#
require "yaml"
ver = YAML.load_file("../pubspec.yaml")["version"]
$vname, $vcode = ver.split('+')[0], ver.split('+')[1]
$vcode_file = "./metadata/android/en-US/changelogs/#{$vcode}.txt"
print "Version: #{ver}\n"
#
$project_name = ENV["PROJECT"].split('.')[-1]
$apk_to_upload = "#{ENV["RELEASE_APK_PATH"]}/#{$project_name}-v#{$vname}.apk"
$repo_name = "dizzib/#{$project_name.sub('_', '-')}"

def rename_apk_for_upload
  apk = ENV["RELEASE_APK"]
  return unless File.file?(apk)
  File.rename(apk, $apk_to_upload)
  File.rename("#{apk}.sha1", "#{$apk_to_upload}.sha1")
end

platform :android do
  desc "Populate changelog"
  lane :populate_changelog do
    changelog = read_changelog(
      section_identifier: "[#{$vname}]"
    )
    file = "./metadata/android/en-US/changelogs/#{$vcode}.txt"
    File.open(file, 'w') do |f| f << changelog end
  end

  desc "Release android to github"
  lane :release_to_github do
    rename_apk_for_upload
    set_github_release(
      repository_name: $repo_name,
      api_token: ENV["GITHUB_TOKEN"],
      name: $vname,
      tag_name: $vname,
      description: (File.read($vcode_file) rescue "No changelog provided"),
      commitish: "dev",
      upload_assets: [$apk_to_upload, "#{$apk_to_upload}.sha1"]
    )
  end
end
