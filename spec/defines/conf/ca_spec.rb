require 'spec_helper'

describe 'ipsec::conf::ca' do
  let(:title) { 'myca' }
  let(:params) do
    {
      'auto'   => 'add',
      'cacert' => '/etc/ssl/certs/myca.pem',
      'crluri' => 'file:///etc/ssl/crls/myca_crl.pem',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it do
        is_expected.to contain_concat__fragment('ca myca').with(
          'target' => '/etc/ipsec.conf',
          'order'  => 2,
        )
      end
      it do
        is_expected.to contain_concat__fragment('ca myca')
          .with_content(%r{^ca myca})
      end
      it do
        is_expected.to contain_concat__fragment('ca myca')
          .with_content(%r{^  auto = add})
      end
      it do
        is_expected.to contain_concat__fragment('ca myca')
          .with_content(%r{^  cacert = /etc/ssl/certs/myca.pem})
      end
      it do
        is_expected.to contain_concat__fragment('ca myca')
          .with_content(%r{^  crluri = file:///etc/ssl/crls/myca_crl.pem})
      end
    end
  end
end
