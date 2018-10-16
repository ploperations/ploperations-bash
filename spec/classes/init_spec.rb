require 'spec_helper'

describe 'bash' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      context 'in undefined stage' do
        let(:facts) do
          facts.merge(classification: {
                        'stage' => nil,
                      })
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'in prod' do
        let(:facts) do
          facts.merge(classification: {
                        'stage' => 'prod',
                      })
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'in stage' do
        let(:facts) do
          facts.merge(classification: {
                        'stage' => 'stage',
                      })
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'in aws' do
        let(:facts) do
          facts.merge(classification: {
                        'stage' => 'aws',
                      })
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
    next unless facts[:os]['family'].eql? 'Solaris'
    context "on sun4v Solaris #{facts[:os]['release']['major']}" do
      context 'in undefined stage' do
        let(:facts) do
          facts.merge(classification: {
                        'stage' => nil,
                      },
                      os: {
                        'architecture' => 'sun4v',
                        'hardware' => 'sun4v',
                      })
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'in prod' do
        let(:facts) do
          facts.merge(classification: {
                        'stage' => 'prod',
                      },
                      os: {
                        'architecture' => 'sun4v',
                        'hardware' => 'sun4v',
                      })
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'in stage' do
        let(:facts) do
          facts.merge(classification: {
                        'stage' => 'stage',
                      },
                      os: {
                        'architecture' => 'sun4v',
                        'hardware' => 'sun4v',
                      })
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
