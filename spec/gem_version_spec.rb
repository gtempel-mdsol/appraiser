# frozen_string_literal: true

require './gem_version'

describe GemVersion do
  let(:gem_version_number) { '1.2.3' }
  let(:ruby_version_number) { '>= 2.2.2' }

  subject(:gem_version) { described_class.new(gem_version_number, ruby_version_number) }

  describe '#gem' do
    it 'returns the gem version' do
      expect(gem_version.gem).to eq(gem_version_number)
    end
  end

  describe '#ruby' do
    it 'returns the ruby version' do
      expect(gem_version.ruby).to eq(ruby_version_number)
    end
  end

  describe '#valid?' do
    it 'returns true when there is both gem and ruby version data' do
      expect(gem_version.valid?).to be true
    end

    context 'when there is a gem version' do
      it 'returns false when the ruby version is blank' do
        gem_version = described_class.new(gem_version_number, '')
        expect(gem_version.valid?).to be false
      end

      it 'returns false when the ruby version is nil' do
        gem_version = described_class.new(gem_version_number, nil)
        expect(gem_version.valid?).to be false
      end
    end

    context 'when there is a ruby version' do
      it 'returns false when the gem version is blank' do
        gem_version = described_class.new('', ruby_version_number)
        expect(gem_version.valid?).to be false
      end

      it 'returns false when the gem version is nil' do
        gem_version = described_class.new(nil, ruby_version_number)
        expect(gem_version.valid?).to be false
      end
    end
  end

  describe '#to_s' do
    context 'when there is version data' do
      it 'returns a non-empty string' do
        text = gem_version.to_s
        expect(text).not_to be_empty
      end
    end
  end
end
