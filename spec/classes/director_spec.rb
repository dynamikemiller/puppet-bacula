require 'spec_helper'

describe 'bacula::director' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_class('bacula::director') }
        it { is_expected.to contain_package('bacula-director-common') }
        it { is_expected.to contain_package('bacula-director-pgsql') }
        it { is_expected.to contain_package('bacula-console') }
      end
    end
  end
end
