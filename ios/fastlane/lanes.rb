require "yaml"
ver = YAML.load_file("../../pubspec.yaml")["version"]
$vname, $vcode = ver.split('+')[0], ver.split('+')[1]

platform :ios do
  $app_identifier = "com.me2christ.bible-feed" # bundle ID -- DO NOT CHANGE!!!
  $api_key = app_store_connect_api_key(
    key_id: "P84TK6TW3J",
    issuer_id: "1393d029-6490-46aa-95a5-27ab94c40cfe",
    key_filepath: "/Users/Shared/secret/ios/AuthKey_P84TK6TW3J.p8",
    duration: 1200, # optional (maximum 1200)
    in_house: false # optional but may be required if using match/sigh
  )

  lane :download_metadata do
    sh "bundle exec fastlane deliver download_metadata --force --api_key '#{$api_key.to_json}' --app_identifier #{$app_identifier}"
  end

  lane :upload_meta do
    desc "Upload metadata"

    $release_notes = read_changelog(
      changelog_path: '../CHANGELOG.md',
      section_identifier: "[#{$vname}]"
    )

    deliver(
      app_review_information: {
        first_name: ENV["APPLE_APP_REVIEW_FIRST_NAME"],
        last_name: ENV["APPLE_APP_REVIEW_LAST_NAME"],
        email_address: ENV["APPLE_APP_REVIEW_EMAIL"],
        phone_number: ENV["APPLE_APP_REVIEW_PHONE"],
      },
      app_version: $vname,
      copyright: "#{Time.now.year} #{ENV["APPLE_APP_REVIEW_FIRST_NAME"]} #{ENV["APPLE_APP_REVIEW_LAST_NAME"]}",
      force: true,
      # ipa: "../build/bible-feed.ipa",
      precheck_include_in_app_purchases: false,
      release_notes: {
        'en-GB' => $release_notes,
      },
      submit_for_review: false,
    )
  end

  lane :upload_ipa_to_testflight do
    desc "Upload ipa to TestFlight"

    upload_to_testflight(
      api_key: $api_key,
      ipa: "../build/ios/ipa/bible_feed.ipa",
      skip_waiting_for_build_processing: true,
      changelog: File.read(File.expand_path("../../CHANGELOG.md", File.dirname(__FILE__)))
    )
  end
end
