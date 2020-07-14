# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Search results displays field', type: :system, clean: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add([dog])
    solr.commit
  end

  let(:dog) do
    {
      id: '111',
      author_tsim: 'Me and You',
      format: 'three dimensional object',
      published_ssim: "1997",
      published_vern_ssim: "1997",
      lc_callnum_ssim: "123213213",
      language_ssim: ['en', 'eng', 'zz'],
      visibility_ssi: 'Public'
    }
  end

  context 'Within search results' do
    subject(:content) { find(:css, '#content') }

    it 'highlights author when a term is queried' do
      visit '/?search_field=all_fields&q=You'
      expect(page.html).to include "Me and <span class='search-highlight'>You</span>"
    end
  end
end