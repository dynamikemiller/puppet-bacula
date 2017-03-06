require 'spec_helper'

describe 'bacula::job' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) {
        'include bacula::client'
      }

      context 'A simple files job' do
        let(:title) { 'Etc' }
        let(:params) { {
          files: ['/etc']
        } }

        it { is_expected.to contain_bacula__job('Etc') }
        it {
          expect(exported_resources).to contain_bacula__director__job('Etc').with_content(
            %r{Job \{\n.*Name.*=.*Etc\n.*Type.*= Backup}
          )
        }

        it {
          expect(exported_resources).to contain_bacula__director__job('Etc').with_content(
            %r{FileSet.*=.*Etc}
          )
        }

        it {
          expect(exported_resources).to contain_bacula__director__fileset('Etc').with_files(
            ['/etc']
          )
        }

      end

      context 'with job_tag' do
        let(:title) { 'Etc' }
        let(:params) { {
          files: ['/etc'],
          job_tag: 'simple',
        } }

        it { is_expected.to contain_bacula__job('Etc') }
      end

    end
  end
end

