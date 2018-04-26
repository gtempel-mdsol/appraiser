# frozen_string_literal: true

require './gem_info'
require './gem_info'
require './gem_version'

describe GemInfo do
  subject(:gem_info) { described_class.new('my_gem') }

  let(:current_version_number) { '1.2.3' }
  let(:newer_version_number) { '1.5.3' }
  let(:ruby_version_number) { '>= 1.9.3' }
  let(:current_version) do
    instance_double(GemVersion,
                    gem: current_version_number,
                    ruby: ruby_version_number)
  end
  let(:newer_version) do
    instance_double(GemVersion,
                    gem: newer_version_number,
                    ruby: ruby_version_number)
  end

  describe '#valid?' do
    context 'when there is no name' do
      it 'returns false when the name is blank' do
        gem_info = described_class.new('')
        expect(gem_info.valid?).to be false
      end

      it 'returns false when the name is nil' do
        gem_info = described_class.new(nil)
        expect(gem_info.valid?).to be false
      end
    end

    context 'when there is a name' do
      it 'returns true when there is a valid current version' do
        gem_info.current_version = instance_double(GemVersion, valid?: true)
        expect(gem_info.valid?).to be true
      end

      it 'returns false when there is an invalid current version' do
        gem_info.current_version = instance_double(GemVersion, valid?: false)
        expect(gem_info.valid?).to be false
      end

      it 'returns false when there is no current version' do
        expect(gem_info.valid?).to be false
      end
    end
  end

  describe '#current_version' do
    context 'when there is a current version' do
      it 'returns the current version' do
        gem_info.current_version = current_version
        expect(gem_info.current_version).to eq(current_version)
      end
    end
  end

  describe '#newest_version' do
    context 'when there is a newest version' do
      it 'returns the newest version' do
        gem_info.newest_version = newer_version
        expect(gem_info.newest_version).to eq(newer_version)
      end
    end
  end

  describe '#newer_version?' do
    context 'when there is no newer version' do
      it 'returns false' do
        expect(gem_info.newer_version?).to be false
      end
    end

    context 'when there is a newer version' do
      it 'returns false when the newer version is invalid' do
        gem_info.newest_version = instance_double(GemVersion, valid?: false)
        expect(gem_info.newer_version?).to be false
      end

      it 'returns false when the newer version is valid' do
        gem_info.newest_version = instance_double(GemVersion, valid?: true)
        expect(gem_info.newer_version?).to be true
      end

      it 'returns false when the newer version is nil' do
        gem_info.newest_version = nil
        expect(gem_info.newer_version?).to be false
      end
    end
  end
end
