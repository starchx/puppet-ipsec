require 'spec_helper'

describe 'ipsec' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'module structure' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('ipsec') }
        it { is_expected.to contain_class('ipsec::install').that_comes_before('Class[ipsec::config]') }
        it { is_expected.to contain_class('ipsec::config').that_notifies('Class[ipsec::service]') }
        it { is_expected.to contain_class('ipsec::service') }
      end
      describe 'install' do
        it do
          is_expected.to contain_package('strongswan')
            .with_ensure('present')
        end
      end
      describe 'config' do
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_ensure('file')
            .with_group(0)
            .with_owner(0)
            .with_mode('0600')
        end
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_content(%r{^@example.org : PSK "asdf1234"$})
        end
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_content(%r{^rsa-a.example.org : RSA /etc/ipsec.d/private/host-a.key %prompt$})
        end
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_content(%r{^rsa-b.example.org : RSA /etc/ipsec.d/private/host-b.key "asdf1234"$})
        end
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_content(%r{^ : RSA /etc/ipsec.d/private/host-def.key$})
        end
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_content(%r{^ : PIN %smartcard1:50 1234$})
        end
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_content(%r{^ : PIN %smartcard1@opensc:45 %prompt$})
        end
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_content(%r{^include /var/lib/strongswan/ipsec.secrets.inc$})
        end
        it do
          is_expected.to contain_file('/etc/ipsec.secrets')
            .with_content(%r{^include /etc/ipsec.d/very.secret$})
        end
      end
      describe 'service' do
        it do
          is_expected.to contain_service('strongswan')
            .with(
              'enable'    => true,
              'hasstatus' => false,
              'restart'   => '/usr/sbin/ipsec reload',
            )
        end
      end
    end
  end
end
