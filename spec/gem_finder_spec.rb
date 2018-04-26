# frozen_string_literal: true

require './gem_finder'

describe GemFinder do
  let(:rubygems) { instance_double(RubyGems) }
  let(:name) { 'my_gem_name' }
  let(:version) { '1.2.3' }
  let(:ruby_version) { '>=1.9.3' }

  let(:newest_version) { '1.3.5' }
  let(:newest_ruby_version) { '>=2.2.2' }

  subject(:gem_finder) { described_class.new(rubygems) }

  describe '#search' do
    context 'when search data describes single gem version' do
      let(:search_data) { { name: name, version: version } }

      before do
        allow(rubygems).to receive(:find).once.ordered.with(name, version).and_return(name: name, version: version, ruby_version: ruby_version)
      end

      it 'returns a GemInfo object with the gem version' do
        gem_info = gem_finder.search search_data
        expect(gem_info.current_version.gem).to eq(version)
      end

      it 'returns a GemInfo object with the gem ruby version' do
        gem_info = gem_finder.search search_data
        expect(gem_info.current_version.ruby).to eq(ruby_version)
      end

      it 'returns a GemInfo object with no newest-version info' do
        gem_info = gem_finder.search search_data
        expect(gem_info.newest_version).to be_nil
      end
    end

    context 'when search data describes an outdated gem' do
      let(:search_data) { { name: name, version: version, newest: newest_version } }

      before do
        allow(rubygems).to receive(:find).once.ordered.with(name, version).and_return(name: name, version: version, ruby_version: ruby_version)
        allow(rubygems).to receive(:find).once.ordered.with(name, newest_version).and_return(name: name, version: newest_version, ruby_version: newest_ruby_version)
      end

      it 'returns a GemInfo object with newest version' do
        gem_info = gem_finder.search search_data
        expect(gem_info.newest_version.gem).to eq(newest_version)
      end

      it 'returns a GemInfo object with newest gem ruby version info' do
        gem_info = gem_finder.search search_data
        expect(gem_info.newest_version.ruby).to eq(newest_ruby_version)
      end
    end
  end

  describe '#detect_ruby_version' do
    context 'when gem info contains a ruby version' do
      it 'returns the ruby version string when not empty or nil' do
        rubygems_data = {
          name: name,
          version: version,
          ruby_version: ruby_version
        }
        detected_version = gem_finder.detect_ruby_version rubygems_data
        expect(detected_version).to eq(ruby_version)
      end

      it 'returns ? when empty or nil' do
        rubygems_data = {
          name: name,
          version: version,
          ruby_version: nil
        }
        detected_version = gem_finder.detect_ruby_version rubygems_data
        expect(detected_version).to eq('?')
      end
    end

    it 'returns ? when rubygems_data is nil' do
      detected_version = gem_finder.detect_ruby_version nil
      expect(detected_version).to eq('?')
    end

    it 'returns ? when rubygems_data is missing ruby_version' do
      rubygems_data = {
        name: name,
        version: version
      }
      detected_version = gem_finder.detect_ruby_version rubygems_data
      expect(detected_version).to eq('?')
    end
  end
end
