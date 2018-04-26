# frozen_string_literal: true

require './ruby_versioner'
require './gem_info'
require './gem_version'

describe RubyVersioner do
  let(:gem_name) { 'my_gem' }
  let(:current_version_number) { '1.2.3' }
  let(:newer_version_number) { '1.5.3' }
  let(:ruby1_version_number) { '>= 1.9.3' }
  let(:ruby2_version_number) { '>= 2.2.2' }
  let(:current_version) { instance_double(GemVersion, gem: current_version_number, ruby: ruby1_version_number) }
  let(:newer_version) { instance_double(GemVersion, gem: newer_version_number, ruby: ruby2_version_number) }

  subject(:ruby_versioner) { described_class.new }

  describe '#<<' do
    context 'when the gem info is valid' do
      context 'when the gem info has only a current version' do
        let(:gem_info) do
          instance_double(GemInfo,
                          name: gem_name,
                          current_version: current_version,
                          newer_version?: false,
                          valid?: true)
        end

        it 'adds the gem current ruby version to the collection' do
          ruby_versioner << gem_info
          expect(ruby_versioner.ruby_versions).not_to be_empty
        end

        it 'adds the gem name and version to the ruby version collection' do
          ruby_versioner << gem_info
          expect(ruby_versioner.ruby_version(current_version.ruby)).to eq(["#{gem_name} #{current_version.gem}"])
        end
      end

      context 'when the gem info has different current and newest version ruby requirements' do
        let(:gem_info) do
          instance_double(GemInfo,
                          name: gem_name,
                          current_version: current_version,
                          newer_version?: true,
                          newest_version: newer_version,
                          valid?: true)
        end

        it 'adds the gem current and newest ruby versions to the collection' do
          ruby_versioner << gem_info
          expect(ruby_versioner.ruby_versions.count).to eq(2)
        end
      end
    end

    context 'when the gem info is invalid' do
      let(:gem_info) { instance_double(GemInfo, name: gem_name, valid?: false) }

      it 'does not add the gem info to the collection' do
        ruby_versioner << gem_info
        expect(ruby_versioner.ruby_versions).to be_empty
      end
    end
  end

  describe '#ruby_versions' do
    context 'when gem info has a single ruby version' do
      let(:gem_info) do
        instance_double(GemInfo,
                        name: gem_name,
                        current_version: current_version,
                        newer_version?: false,
                        valid?: true)
      end

      it 'adds a single ruby version to the collection' do
        ruby_versioner << gem_info
        expect(ruby_versioner.ruby_versions).to match_array([ruby1_version_number])
      end
    end

    context 'when gem info has multiple ruby versions' do
      let(:gem_info) do
        instance_double(GemInfo,
                        name: gem_name,
                        current_version: current_version,
                        newer_version?: true,
                        newest_version: newer_version,
                        valid?: true)
      end

      it 'adds a each ruby version to the collection' do
        ruby_versioner << gem_info
        expect(ruby_versioner.ruby_versions).to match_array([ruby1_version_number, ruby2_version_number])
      end
    end

    context 'when gem info has duplicate ruby versions' do
      let(:gem_info) do
        instance_double(GemInfo,
                        name: gem_name,
                        current_version: current_version,
                        newer_version?: true,
                        newest_version: current_version,
                        valid?: true)
      end

      it 'adds a single ruby version to the collection' do
        ruby_versioner << gem_info
        expect(ruby_versioner.ruby_versions).to match_array([ruby1_version_number])
      end
    end
  end

  describe '#ruby_version' do
    context 'when gem info has a ruby version' do
      let(:gem_info) do
        instance_double(GemInfo,
                        name: gem_name,
                        current_version: current_version,
                        newer_version?: false,
                        valid?: true)
      end

      it 'adds the gem name and version to the list for the ruby version' do
        ruby_versioner << gem_info
        expect(ruby_versioner.ruby_version(ruby1_version_number)).not_to be_empty
      end
    end
  end
end
