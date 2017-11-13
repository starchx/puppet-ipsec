require 'spec_helper'

describe 'ipsec::conf::conn' do
  let(:title) { 'test' }
  let(:params) do
    {
      'type'     => 'transport',
      'left'     => '%any',
      'leftcert' => 'hostcert.pem',
      'right'    => '192.168.56.1',
      'rightid'  => '%any',
      'auto'     => 'route',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it do
        is_expected.to contain_concat__fragment('conn test').with(
          'target' => '/etc/ipsec.conf',
          'order'  => 3,
        )
      end
      it do
        is_expected.to contain_concat__fragment('conn test')
          .with_content(%r{conn test$})
      end
      it do
        is_expected.to contain_concat__fragment('conn test')
          .with_content(%r{^  type = transport$})
      end
      it do
        is_expected.to contain_concat__fragment('conn test')
          .with_content(%r{^  left = %any$})
      end
      it do
        is_expected.to contain_concat__fragment('conn test')
          .with_content(%r{^  leftcert = hostcert.pem$})
      end
      it do
        is_expected.to contain_concat__fragment('conn test')
          .with_content(%r{^  right = 192.168.56.1$})
      end
      it do
        is_expected.to contain_concat__fragment('conn test')
          .with_content(%r{^  rightid = %any$})
      end
      it do
        is_expected.to contain_concat__fragment('conn test')
          .with_content(%r{^  auto = route$})
      end
    end
  end
end
