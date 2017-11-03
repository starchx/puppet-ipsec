require 'spec_helper_acceptance'

describe 'ipsec module' do
  it 'class should apply successfully on first shot' do
    manifest = %(
      class { 'ipsec':
      }
    )
    # first apply should not log any error message
    apply_manifest(manifest, catch_failures: true) do |res|
      expect(res.stderr).not_to match(%r{error})
    end
    # second apply should not change anything
    apply_manifest(manifest, catch_failures: true) do |res|
      expect(res.stderr).not_to match(%r{error})
      expect(res.exit_code).to be_zero
    end
  end # it 'class should apply successfully on first shot'
  # TODO: add tests here!
end # describe 'ipsec module'
