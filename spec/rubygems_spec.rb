require './rubygems'

describe RubyGems do

  subject(:rubygems) { RubyGems.new }

  let(:name) { 'my_gem_name' }
  let(:version) { '1.2.3' }

  describe '#url_for' do
    context 'when given a gem name and version' do
      it 'returns a URL string' do
        url = rubygems.url_for name, version
        expect(url).to include(name)
        expect(url).to include(version)
      end
    end
  end

  describe '#find' do
    # this scenario is manually constructed, and treats ALL
    # of typhoeus as a black box
    context 'when given an existing gem name and version' do
      let(:response) do
        double(
          response_body: %({"name": "#{name}", "version": "#{version}"}),
          success?: true
        )
      end
      it 'returns parsed json object from rubygems' do
        url = rubygems.url_for name, version
        allow(Typhoeus).to receive(:get).with(url, followlocation: true).and_return(response)
        expect(rubygems.find name, version).not_to be_nil
      end
    end

    # these scenarios use the stubbing feature(s) of Typhoeus
    # which allows for a bit more detail
    context 'when stubbing and the search has a success code' do
      it 'returns parsed json object from rubygems' do
        url = rubygems.url_for name, version
        response = Typhoeus::Response.new(code: 200, body: %({"name": "#{name}", "version": "#{version}"}))
        Typhoeus.stub(url).and_return(response)
        expect(rubygems.find name, version).not_to be_nil
      end
    end

    context 'when stubbing and the search is unsuccessful' do 
      it 'returns nil' do
        url = rubygems.url_for name, version
        response = Typhoeus::Response.new(code: 404, body: 'gem not found')
        Typhoeus.stub(url).and_return(response)
        expect(rubygems.find name, version).to be_nil
      end
    end

    context 'when stubbing and the search attempt fails' do 
      it 'returns nil' do
        url = rubygems.url_for name, version
        Typhoeus.stub(url).and_return(nil)
        expect(rubygems.find name, version).to be_nil
      end
    end

  end
end