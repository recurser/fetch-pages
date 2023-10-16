# frozen_string_literal: true

require 'rspec'
require 'timecop'
require 'webmock/rspec'

require_relative '../src/page'

# rubocop:disable Metrics/BlockLength
describe Page do
  let(:url) { 'http://example.com/test_page' }
  let(:sample_html) { "<html><body><a href='link1'></a><img src='img1'></img></body></html>" }
  let(:page) { described_class.new(url) }

  before do
    stub_request(:get, url).to_return(body: sample_html, status: 200)
  end

  describe '#initialize' do
    it 'sets the provided URL' do
      expect(page.url).to eq(url)
    end
  end

  describe '#fetch' do
    it 'fetches the page source' do
      page.fetch
      expect(page.html).to eq(sample_html)
    end

    it 'raises an error if a problem occurs' do
      stub_request(:get, url).to_return(body: nil, status: 500)
      expect do
        page.fetch
      end.to raise_error('The page could not be fetched (http://example.com/test_page)')
    end

    it 'sets the last fetched time' do
      now = Time.now
      Timecop.freeze(now) do
        page.fetch
        expect(page.last_fetched_at).to eq(now)
      end
    end

    context 'when metadata option is true' do
      let(:page) { described_class.new(url, metadata: true) }

      it 'prints metadata' do
        allow(page).to receive(:metadata)
        page.fetch
        expect(page).to have_received(:metadata)
      end

      it 'does not download' do
        allow(page).to receive(:download!)
        page.fetch
        expect(page).not_to have_received(:download!)
      end
    end
  end

  describe '#download!' do
    before { page.fetch }

    it 'writes the fetched HTML to a local file' do
      expected_filename = 'test-page.html'
      allow(File).to receive(:write)
      page.download!
      expect(File).to have_received(:write).with(expected_filename, sample_html)
    end
  end

  describe '#metadata' do
    before { page.fetch }

    it 'prints the site URL' do
      expect { page.metadata }.to output(/site: #{url}/).to_stdout
    end

    it 'prints the number of links' do
      expect { page.metadata }.to output(/num_links: 1/).to_stdout
    end

    it 'prints the number of images' do
      expect { page.metadata }.to output(/images: 1/).to_stdout
    end

    it 'prints the last fetch time' do
      expect { page.metadata }.to output(/last_fetch:/).to_stdout
    end
  end

  describe '#num_images' do
    before { page.fetch }

    it 'returns the number of images in the HTML' do
      expect(page.num_images).to eq(1)
    end
  end

  describe '#num_links' do
    before { page.fetch }

    it 'returns the number of links in the HTML' do
      expect(page.num_links).to eq(1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
