# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Search results displays field', type: :system, clean: true, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add([dog, cat])
    solr.commit
    visit '/?search_field=all_fields&q='
  end

  let(:search_fields) { CatalogController.blacklight_config.search_fields.keys }
  let(:expected_search_fields) do
    ["all_fields", "author_tsim", "orbisBibId_ssim", "subjectName_ssim", "title_tsim"]
  end

  let(:dog) do
    {
      id: '111',
      title_tsim: 'Handsome Dan is a bull dog.',
      author_tsim: 'Eric & Frederick',
      subjectName_ssim: "this is the subject name",
      sourceTitle_ssim: "this is the source title",
      orbisBibId_ssim: '1238901',
      visibility_ssi: 'Public'
    }
  end

  let(:cat) do
    {
      id: '212',
      title_tsim: 'Handsome Dan is not a cat.',
      author_tsim: 'Frederick & Eric',
      sourceTitle_ssim: "this is the source title",
      orbisBibId_ssim: '1234567',
      visibility_ssi: 'Public'
    }
  end

  context 'search fields' do
    it ' contains all search fields in the view' do
      expect(search_fields).to contain_exactly(*expected_search_fields)
    end

    it 'contains displays the correct record when searching by BibId' do
      visit '/?search_field=orbisBibId_ssim&q=1238901'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).not_to have_content 'Handsome Dan is not a cat.'
    end

    it 'contains displays the correct record when searching by author' do
      visit '/?search_field=author&q=Eric'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).to have_content 'Handsome Dan is not a cat.'
    end

    it 'contains displays the correct record when searching by subject' do
      visit '/?search_field=subjectName_ssim&q=this+is+the+subject+name'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).not_to have_content 'Handsome Dan is not a cat.'
    end

    it 'contains displays the correct record when searching by title' do
      visit '/?search_field=title_tsim&q=handsome'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).to have_content 'Handsome Dan is not a cat.'
    end
  end
end