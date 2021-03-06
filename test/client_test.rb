# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe Amara::Client do

  it "returns a teams api object" do
    amara = Amara::Client.new
    amara.teams.wont_be_nil
  end

  it "returns a videos api object" do
    amara = Amara::Client.new
    amara.videos.wont_be_nil
  end

  it "returns a languages api object" do
    amara = Amara::Client.new
    amara.languages.wont_be_nil
  end

  it "throws no error on 200" do
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(body: nil, status: 200)
    begin
      Amara::API.new.list(limit: 2)
    rescue
      flunk "Client error should not be thrown!"
    end
  end

  it "throws a client error on 400s (except 404)" do
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(body: nil, status: 400)
    proc {
      Amara::API.new.list(limit: 2)
    }.must_raise Amara::ClientError
  end

  it "throws a not found error on 404" do
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(body: nil, status: 404)
    proc {
      Amara::API.new.list(limit: 2)
    }.must_raise Amara::NotFoundError
  end

  it "throws a server error on 500s" do
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(body: nil, status: 500)
    proc {
      Amara::API.new.list(limit: 2)
    }.must_raise Amara::ServerError
  end

  it "throws an unknown error on all other errors" do
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(body: nil, status: 601)
    proc {
      Amara::API.new.list(limit: 2)
    }.must_raise Amara::UnknownError
  end
end
