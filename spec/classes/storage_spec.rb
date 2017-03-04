require 'spec_helper'

describe 'bacula::storage' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    context "on #{os}" do

      it { should contain_class('bacula::storage') }

      case facts[:osfamily]
      when 'Debian'
      when 'RedHat'
        #case facts[:operatingsystemmajrelease]
        #when '6'
        #  it { should contain_package('bacula-storage-common').with(
        #      'ensure' => 'present',
        #    )
        #  }
        #  it { should_not contain_package('bacula-storage') }
        #else
        #  it { should contain_package('bacula-storage').with(
        #      'ensure' => 'present',
        #    )
        #  }
        #  it { should_not contain_package('bacula-storage-common') }
        #end
      end

    end
  end
end

