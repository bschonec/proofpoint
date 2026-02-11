# frozen_string_literal: true

require 'spec_helper'

describe 'proofpoint', type: :class do
  let(:params) do
    {
      client_id: 'dummy_id',
      client_secret: 'dummy_secret',
      relayuser_name: 'dummy_user',
      relayuser_password: 'dummy_pass'
    }
  end

  let(:facts) do
    {
      osfamily: 'RedHat',
      operatingsystem: 'RedHat',
    }
  end

  context 'with defaults' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_package('ser-connector').with_ensure('installed') }

    it do
      expect(subject).to contain_file('/opt/ser/config/config.yaml').with_owner('ser-connector').with_group('root').with_mode('0644').
        with_content(%r{NDR:\s+  StoreBounces:\s+    Enable: true}s).
        with_content(%r{NDR:\s+  StoreBounces:\s+    Enable: true}s)
    end
  end

  context 'when package_ensure => absent' do
    let(:params) do
      {
        client_id: 'dummy_id',
        client_secret: 'dummy_secret',
        relayuser_name: 'dummy_user',
        relayuser_password: 'dummy_pass',
        package_ensure: 'absent'
      }
    end

    it { is_expected.to contain_package('ser-connector').with_ensure('absent') }
  end

  context 'when custom listeners are provided' do
    let(:params) do
      {
        client_id: 'dummy_id',
        client_secret: 'dummy_secret',
        relayuser_name: 'dummy_user',
        relayuser_password: 'dummy_pass',
        listeners: [
          { 'port' => 2525, 'type' => 'SMTP' },
          { 'port' => 465, 'type' => 'SMTPS', 'certificate' => '/etc/ssl/cert.pem' },
        ],
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/opt/ser/config/config.yaml') }
  end
end
