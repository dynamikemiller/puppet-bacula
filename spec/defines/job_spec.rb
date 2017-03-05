require 'spec_helper'

describe 'bacula::job' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

       let(:pre_condition) {
         'include bacula::client'
       }

      let(:title) { 'Etc' }
      let(:params) { {
        files: ['/etc'] 
      } }
      it { is_expected.to contain_bacula__job('Etc') }
    end
  end
end

