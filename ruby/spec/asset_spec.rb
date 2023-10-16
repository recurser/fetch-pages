# frozen_string_literal: true

require 'rspec'
require_relative '../app/asset'

RSpec.describe Asset do
  let(:page_url) { 'http://example.com' }
  let(:element) {  Nokogiri::HTML('<img src="image2.jpg" />').at_css('img') }
  let(:asset) { described_class.new(page_url, element) }

  before do
    allow(element).to receive(:[]).and_return(nil)
  end

  describe '#mirror!' do
    context 'when asset_url is nil' do
      it 'does not call download!' do
        allow(asset).to receive(:download!)
        asset.mirror!
        expect(asset).not_to have_received(:download!)
      end
    end

    context 'when asset_url is not nil' do
      let(:local_path) { './example.com-assets/img/image.jpg' }

      before do
        allow(element).to receive(:[]).with(:src).and_return('image.jpg')
        allow(element).to receive(:name).and_return('img')
        allow(HTTParty).to receive(:get).and_yield('fake data')
      end

      it 'calls download!' do
        allow(asset).to receive(:download!)
        asset.mirror!
        expect(asset).to have_received(:download!)
      end

      it 'handles relative paths' do
        allow(element).to receive(:[]=).with(:src, local_path)
        asset.mirror!
        expect(element).to have_received(:[]=).with(:src, local_path)
      end

      it 'handles absolute paths' do
        element = Nokogiri::HTML('<img src="https://daveperrett.com/image.jpg" />').at_css('img')
        asset = described_class.new(page_url, element)
        allow(element).to receive(:[]=).with(:src, local_path)
        asset.mirror!
        expect(element).to have_received(:[]=).with(:src, local_path)
      end
    end
  end
end
