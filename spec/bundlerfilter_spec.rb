require './bundlerfilter'

describe BundlerFilter do

  subject(:filter) { BundlerFilter.new }


  describe '#filter?' do
    it 'returns true if input is nil' do
      line = nil
      results = filter.filter? line
      expect(results).to be true
    end

    it 'returns true if input is empty' do
      line = ' '
      results = filter.filter? line
      expect(results).to be true
    end

    it 'returns true if input contains keywords' do
      line = 'Outdated Fetching Gems Resolving'
      results = filter.filter? line
      expect(results).to be true
    end

    it 'returns false when it should not be filtered' do
      line = ' * addressable (newest 2.5.2, installed 2.3.8)'
      results = filter.filter? line
      expect(results).to be false
    end

  end

end