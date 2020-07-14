# frozen_string_literal: true
require 'rails_helper'
require 'net/http'

RSpec.describe HttpAuthConcern, type: :request do
  before do
    @controller = controller
    ENV['HTTP_PASSWORD_PROTECT'] = true.to_s
  end
  after do
    ENV['HTTP_PASSWORD_PROTECT'] = false.to_s
  end

  it "protects sensitive pages" do
    get '/'
    response.status.should == 401
  end

  it 'after sign-in user has access' do
    http_auth = http_login
    get '/', headers: { 'HTTP_AUTHORIZATION' => http_auth }
    response.status.should == 200
  end
end