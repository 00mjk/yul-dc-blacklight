# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Search results should be sorted', type: :system, js: :true, clean: true do
  before do
    solr = Blacklight.default_index.connection
    solr.add([llama,
              dog,
              eagle,
              puppy])
    solr.commit
    visit root_path
  end

  let(:llama) do
    {
      id: '111',
      title_tsim: ['Amor Llama'],
      format: 'text',
      language_ssim: 'la',
      visibility_ssi: 'Public',
      publicationPlace_ssim: 'Spain',
      resourceType_ssim: 'Maps, Atlases & Globes',
      author_ssim: ['Anna Elizabeth Dewdney'],
      dateStructured_ssim: '1911-1954'
    }
  end

  let(:dog) do
    {
      id: '222',
      title_tsim: ['HandsomeDan Bulldog'],
      format: 'three dimensional object',
      language_ssim: 'en',
      visibility_ssi: 'Public',
      publicationPlace_ssim: 'New Haven',
      resourceType_ssim: 'Books, Journals & Pamphlets',
      author_ssim: ['Andy Graves'],
      dateStructured_ssim: '1755-00-00T00:00:00Z'
    }
  end

  let(:puppy) do
    {
      id: '444',
      title_tsim: ['Rhett Lecheire'],
      format: 'text',
      language_ssim: 'fr',
      visibility_ssi: 'Public',
      publicationPlace_ssim: 'Constantinople or southern Italy',
      resourceType_ssim: 'Archives or Manuscripts',
      author_ssim: ['Paulo Coelho'],
      dateStructured_ssim: '1972200'
    }
  end

  let(:eagle) do
    {
      id: '333',
      title_tsim: ['Aquila Eccellenza'],
      format: 'still image',
      language_ssim: 'it',
      visibility_ssi: 'Public',
      publicationPlace_ssim: 'White-Hall, printed upon the ice, on the River Thames',
      resourceType_ssim: 'Archives or Manuscripts',
      author_ssim: ['Andrew Norriss'],
      dateStructured_ssim: '1699'
    }
  end

  it 'sorts by date from oldest to newest' do
    click_on 'Search'
    click_on 'Sort by relevance'
    click_on 'date (oldest first)'

    content = find(:css, '#content')
    expect(content).to have_content('1. Aquila Eccellenza')
    expect(content).to have_content('2. HandsomeDan Bulldog')
    expect(content).to have_content('3. Amor Llama')
    expect(content).to have_content('4. Rhett Lecheire')
  end

  it 'sorts by date from newest to oldest' do
    click_on 'Search'
    click_on 'Sort by relevance'
    click_on 'date (newest first)'

    content = find(:css, '#content')
    expect(content).to have_content('1. Rhett Lecheire')
    expect(content).to have_content('2. Amor Llama')
    expect(content).to have_content('3. HandsomeDan Bulldog')
    expect(content).to have_content('4. Aquila Eccellenza')
  end
end