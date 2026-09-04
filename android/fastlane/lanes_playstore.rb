ensure_env_vars(env_vars: ['FR_AAB_PATH'])

desc "Deploy to Google Play internal"
lane :gplay_internal do
  upload_to_play_store(
    aab: ENV['FR_AAB'],
    # mapping_paths: [ENV['MAPPING_FILE_PATH']],
    release_status: 'draft',
    skip_upload_aab: false,
    skip_upload_images: true,
    skip_upload_screenshots: true,
    track: 'internal',
    version_code: $vcode,
  )
end

desc "Promote internal test to closed"
lane :gplay_promote_internal_to_closed do
  upload_to_play_store(
    aab: ENV['FR_AAB'],
    release_status: 'draft',
    skip_upload_aab: true,
    skip_upload_metadata: true,
    skip_upload_changelogs: true,
    skip_upload_images: true,
    skip_upload_screenshots: true,
    track: 'internal',
    track_promote_to: "alpha",
    version_code: $vcode,
  )
end

desc "Upload metadata to Google Play"
lane :upload_metadata do
  upload_to_play_store(
    aab: ENV['FR_AAB'],
    skip_upload_aab: true,
    skip_upload_changelogs: true,
    skip_upload_metadata: false,
    skip_upload_images: false,
    skip_upload_screenshots: false,
    track: 'internal',
    version_code: $vcode,
  )
end
