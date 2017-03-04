require 'spec_helper' 

describe 'bacula::client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      it { should contain_class('bacula::client') }
    end
  end
end

