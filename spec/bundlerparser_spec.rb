# frozen_string_literal: true

require './bundlerparser'

describe BundlerParser do
  subject(:parser) { BundlerParser.new }

  let(:name) { 'my_gem_name' }
  let(:version) { '1.2.3' }
  let(:newest_version) { '1.3.5' }

  describe '#parse' do
    context 'when bundler list data is provided' do
      it 'returns a non-empty hash' do
        bundler_record = "  * #{name} (#{version})"
        results = parser.parse bundler_record
        expect(results).not_to be_nil
        expect(results).to be_a_kind_of(Hash)
        expect(results).not_to be_empty
      end
    end

    context 'when bundler outdated data is provided' do
      it 'returns a non-empty hash' do
        bundler_record = "  * #{name} (newest #{newest_version}, installed #{version})"
        results = parser.parse bundler_record
        expect(results).not_to be_nil
        expect(results).to be_a_kind_of(Hash)
        expect(results).not_to be_empty
      end
    end

    context 'when unusable data is provided' do
      it 'returns nil' do
        bundler_record = " * (#{version}) foo "
        results = parser.parse bundler_record
        expect(results).to be_nil
      end
    end
  end

  describe '#match_bundle_list' do
    context 'when bundler provides list info' do
      it 'returns nil if the data is malformed' do
        bundler_record = " * (#{version}) foo "
        results = parser.match_bundle_list bundler_record
        expect(results).to be_nil
      end

      it 'returns a hash with the gem name and current version' do
        bundler_record = "  * #{name} (#{version})"
        results = parser.match_bundle_list bundler_record
        expect(results).to eq(name: name, version: version)
      end

      it 'returns a hash with the gem name and current version, ignoring git SHA' do
        bundler_record = "  * #{name} (#{version} 0487461)"
        results = parser.match_bundle_list bundler_record
        expect(results).to eq(name: name, version: version)
      end
    end
  end

  describe '#match_bundle_outdated' do
    context 'when bundler provides outdated info' do
      it 'returns nil if the list info is malformed' do
        bundler_record = " * (#{version}) foo "
        results = parser.match_bundle_outdated bundler_record
        expect(results).to be_nil
      end

      it 'returns a hash with the gem name, current and newest versions' do
        bundler_record = "  * #{name} (newest #{newest_version}, installed #{version})"
        results = parser.match_bundle_outdated bundler_record
        expect(results).to eq(name: name, version: version, newest: newest_version)
      end

      it 'returns a hash with the gem name, current and newest versions, ignoring requested version' do
        bundler_record = "  * #{name} (newest #{newest_version}, installed #{version}, requested ~> 1.9)"
        results = parser.match_bundle_outdated bundler_record
        expect(results).to eq(name: name, version: version, newest: newest_version)
      end
    end
  end
end
