# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Search results displays field', type: :system, clean: true, js: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add([dog, cat])
    solr.commit
    visit '/catalog?search_field=all_fields&q='
  end

  let(:search_fields) { CatalogController.blacklight_config.search_fields.keys }
  let(:expected_search_fields) do
    ["all_fields", "all_fields_advanced", "creator_tesim", "child_oids_ssim", "date_fields", "genre_fields",
     "identifierShelfMark_tesim", "oid_ssi", "orbisBibId_ssi", "subjectName_ssim", "subject_fields", "title_tesim"]
  end

  let(:dog) do
    {
      id: '111',
      title_tesim: 'Handsome Dan is a bull dog.',
      creator_tesim: 'Eric & Frederick',
      subjectName_ssim: "this is the subject name",
      sourceTitle_tesim: "this is the source title",
      identifierShelfMark_tesim: 'WA MSS 987',
      orbisBibId_ssi: '1238901',
      visibility_ssi: 'Public'
    }
  end

  let(:cat) do
    {
      id: '212',
      title_tesim: 'Handsome Dan is not a cat.',
      creator_tesim: 'Frederick & Eric',
      sourceTitle_tesim: "this is the source title",
      orbisBibId_ssi: '1234567',
      identifierShelfMark_tesim: 'Yale MS 123',
      visibility_ssi: 'Public'
    }
  end

  context 'search fields' do
    it ' contains all search fields in the view' do
      expect(search_fields).to contain_exactly(*expected_search_fields)
    end

    it 'contains displays the correct record when searching by call number' do
      visit '/catalog?search_field=identifierShelfMark_tesim&q=WA+MSS+987'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).not_to have_content 'Handsome Dan is not a cat.'
    end

    it 'contains displays the correct record when searching by BibId' do
      visit '/catalog?search_field=orbisBibId_ssi&q=1238901'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).not_to have_content 'Handsome Dan is not a cat.'
    end

    it 'contains displays the correct record when searching by creator' do
      visit '/catalog?search_field=creator&q=Eric'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).to have_content 'Handsome Dan is not a cat.'
    end

    it 'contains displays the correct record when searching by subject' do
      visit '/catalog?search_field=subjectName_ssim&q=this+is+the+subject+name'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).not_to have_content 'Handsome Dan is not a cat.'
    end

    it 'contains displays the correct record when searching by title' do
      visit '/catalog?search_field=title_tesim&q=handsome'
      expect(page).to have_content 'Handsome Dan is a bull dog.'
      expect(page).to have_content 'Handsome Dan is not a cat.'
    end
  end
end
