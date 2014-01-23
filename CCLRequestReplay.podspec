Pod::Spec.new do |spec|
  spec.name = 'CCLRequestReplay'
  spec.version = '0.9.0'
  spec.license = 'BSD'
  spec.summary = 'Powerful library to replay HTTP responses'
  spec.homepage = 'https://github.com/cocodelabs/CCLRequestReplay'
  spec.authors = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.social_media_url = 'https://twitter.com/kylefuller'
  spec.source = { :git => 'https://github.com/cocodelabs/CCLRequestReplay.git', :tag => spec.version.to_s }

  spec.requires_arc = true
  spec.osx.deployment_target = '10.7'
  spec.ios.deployment_target = '5.0'
  spec.header_dir = 'CCLRequestReplay'

  spec.subspec 'Manager' do |core_spec|
    core_spec.source_files = 'CCLRequestReplay/CCLRequestReplayManager.{h,m}', 'CCLRequestReplay/CCLRequestRecording.{h,m}'
  end

  spec.subspec 'Replay' do |replay_spec|
    replay_spec.source_files = 'CCLRequestReplay/CCLRequestReplayProtocol.{h,m}'
  end

  spec.subspec 'Record' do |record_spec|
    record_spec.source_files = 'CCLRequestReplay/CCLRequestRecordProtocol.{h,m}'
  end
end

