platform :ios do
  lane :build_ipa do
    desc "Build release ipa"
    $app_identifier = "com.me2christ.bible-feed" # bundle ID
    $profile_name = "com.me2christ.bible-feed provisioning profile" # Found in Xcode > Signing & Capabilities

    cocoapods(
      clean_install: true,
      podfile: "Podfile"
    )

    build_ios_app(
      workspace: "../ios/Runner.xcworkspace",
      # scheme: "YOUR_SCHEME", # Typically the same as your project name
      export_method: "app-store",
      clean: true,
      export_options: {
        provisioningProfiles: {
          $app_identifier => $profile_name
        },
        method: "app-store-connect"
      },
      output_directory: "../build",
      output_name: "bible-feed.ipa"
    )
  end

  lane :upload_ipa do
    desc "Upload ipa to TestFlight"
    $api_key = app_store_connect_api_key(
      key_id: "P84TK6TW3J",
      issuer_id: "1393d029-6490-46aa-95a5-27ab94c40cfe",
      key_filepath: "/Users/Shared/secret/ios/AuthKey_P84TK6TW3J.p8",
      duration: 1200, # optional (maximum 1200)
      in_house: false # optional but may be required if using match/sigh
    )

    upload_to_testflight(
      api_key: $api_key,
      ipa: "../build/bible-feed.ipa",
      skip_waiting_for_build_processing: true,
      changelog: File.read(File.expand_path("../../CHANGELOG.md", File.dirname(__FILE__)))
    )
  end
end

