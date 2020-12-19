RSpec.describe BehindTheName do
  before do
    allow(BehindTheName).to receive(:api_key).and_return('APIKEY')
  end

  it "has a version number" do
    expect(BehindTheName::VERSION).not_to be nil
  end

  describe '.lookup' do
    it 'will be angry withour a name' do
      expect { BehindTheName.lookup }.to raise_error(ArgumentError)
    end

    it 'will normalize false to no' do
      allow(RestClient).to receive(:get) do |url, options|
        expect(options.dig(:params, :exact)).to eq('no')
      end.and_return('{}')
      BehindTheName.lookup(name: 'whatever', exact: false)
    end

    it 'will normalize true to no' do
      allow(RestClient).to receive(:get) do |url, options|
        expect(options.dig(:params, :exact)).to eq('yes')
      end.and_return('{}')
      BehindTheName.lookup(name: 'whatever', exact: true)
    end
  end

  describe '.random' do
    it 'will use appendix2 for usage' do
      allow(RestClient).to receive(:get).and_return('{}')
      expect(BehindTheName::Usages).to receive(:from).with(:appendix2).and_call_original
      BehindTheName.random(usage: :scam)
    end

    it 'will normalize fullname usage' do
      allow(RestClient).to receive(:get) do |url, options|
        expect(options.dig(:params, :usage)).to eq(:scam)
      end.and_return('{}')
      BehindTheName.random(usage: 'Norse Mythology')
    end

    it 'will ParamError for invalid genders' do
      expect { BehindTheName.random(gender: :invalid) }.to raise_error(BehindTheName::ParamError)
      expect { BehindTheName.random(gender: 'male') }.to raise_error(BehindTheName::ParamError)
    end

    it 'will ParamError for invalid numbers' do
      expect { BehindTheName.random(number: :invalid) }.to raise_error(BehindTheName::ParamError)
      expect { BehindTheName.random(number: 'male') }.to raise_error(BehindTheName::ParamError)
      expect { BehindTheName.random(number: 1.5) }.to raise_error(BehindTheName::ParamError)
    end

    it 'will normalize false to no' do
      allow(RestClient).to receive(:get) do |url, options|
        expect(options.dig(:params, :randomsurname)).to eq('no')
      end.and_return('{}')
      BehindTheName.random(randomsurname: false)
    end

    it 'will normalize true to no' do
      allow(RestClient).to receive(:get) do |url, options|
        expect(options.dig(:params, :randomsurname)).to eq('yes')
      end.and_return('{}')
      BehindTheName.random(randomsurname: true)
    end
  end

  describe '.related' do
    it 'will be angry withour a name' do
      expect { BehindTheName.related }.to raise_error(ArgumentError)
    end

    it 'will use appendix2 for usage' do
      allow(RestClient).to receive(:get).and_return('{}')
      expect(BehindTheName::Usages).to receive(:from).with(:appendix1).and_call_original
      BehindTheName.related(name: 'Embla', usage: :'sca-myth')
    end

    it 'will normalize fullname usage' do
      allow(RestClient).to receive(:get) do |url, options|
        expect(options.dig(:params, :usage)).to eq(:'sca-myth')
      end.and_return('{}')
      BehindTheName.related(name: 'Embla', usage: 'Norse Mythology')
    end

    it 'will ParamError for invalid genders' do
      expect { BehindTheName.related(name: 'name', gender: :invalid) }.to raise_error(BehindTheName::ParamError)
      expect { BehindTheName.related(name: 'name', gender: 'male') }.to raise_error(BehindTheName::ParamError)
    end
  end
end
