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
  spec.source_files = 'CCLRequestReplay/CCLRequestReplay.h'

  spec.subspec 'Manager' do |core_spec|
    core_spec.source_files = 'CCLRequestReplay/CCLRequestReplayManager.{h,m}', 'CCLRequestReplay/CCLRequestRecording.{h,m}'
  end

  spec.subspec 'Replay' do |replay_spec|
    replay_spec.source_files = 'CCLRequestReplay/CCLRequestReplayProtocol{Private.h,.h,.m}'
    replay_spec.public_header_files = 'CCLRequestReplay/CCLRequestReplayProtocol.h'
    replay_spec.dependency 'CCLRequestReplay/Manager'
  end

  spec.subspec 'Record' do |record_spec|
    record_spec.source_files = 'CCLRequestReplay/CCLRequestRecordProtocol{Private.h,.h,.m}'
    record_spec.public_header_files = 'CCLRequestReplay/CCLRequestRecordProtocol.h'
    record_spec.dependency 'CCLRequestReplay/Manager'
  end

  spec.subspec 'XCTest' do |xctest_spec|
    xctest_spec.source_files = 'CCLRequestReplay/XCTest+CCLRequestReplay.{h,m}'
    xctest_spec.frameworks = 'XCTest'
    xctest_spec.dependency 'CCLRequestReplay/Manager'
    xctest_spec.dependency 'CCLRequestReplay/Replay'
  end

  spec.subspec 'Blueprint' do |blueprint_spec|
    blueprint_spec.source_files = 'CCLRequestReplay/CCLRequestReplayManager+Blueprint.{h,m}'
  end
end

