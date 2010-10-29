require 'createsend'
require 'json'

class Client
  attr_reader :client_id

  def initialize(client_id)
    @client_id = client_id
  end

  def self.create(company, contact_name, email, timezone, country)
    options = { :body => { 
      :CompanyName => company, 
      :ContactName => contact_name,
      :EmailAddress => email,
      :TimeZone => timezone,
      :Country => country }.to_json }
    CreateSend.post "/clients.json", options
  end

  def details
    response = CreateSend.get "/clients/#{client_id}.json", {}
    Hashie::Mash.new(response)
  end

  def campaigns
    response = get 'campaigns'
    response.map{|item| Hashie::Mash.new(item)}
  end

  def drafts
    response = get 'drafts'
    response.map{|item| Hashie::Mash.new(item)}
  end

  def lists
    response = get 'lists'
    response.map{|item| Hashie::Mash.new(item)}
  end

  def segments
    response = get 'segments'
    response.map{|item| Hashie::Mash.new(item)}
  end

  def suppressionlist
    response = get 'suppressionlist'
    response.map{|item| Hashie::Mash.new(item)}
  end
  
  def templates
    response = get 'templates'
    response.map{|item| Hashie::Mash.new(item)}
  end

  def set_basics(company, contact_name, email, timezone, country)
    options = { :body => { 
      :CompanyName => company, 
      :ContactName => contact_name,
      :EmailAddress => email,
      :TimeZone => timezone,
      :Country => country }.to_json }
    put 'setbasics', options
  end

  def set_access(username, password, access_level)
    options = { :body => { 
      :Username => username, 
      :Password => password, 
      :AccessLevel => access_level }.to_json }
    put 'setaccess', options
  end

  def set_payg_billing(currency, can_purchase_credits, client_pays, markup_percentage, 
    markup_on_delivery=0, markup_per_recipient=0, markup_on_design_spam_test=0)
    options = { :body => { 
      :Currency => currency,
      :CanPurchaseCredits => can_purchase_credits,
      :ClientPays => client_pays,
      :MarkupPercentage => markup_percentage,
      :MarkupOnDelivery => markup_on_delivery,
      :MarkupPerRecipient => markup_per_recipient,
      :MarkupOnDesignSpamTest => markup_on_design_spam_test }.to_json }
    put 'setpaygbilling', options
  end

  def set_monthly_billing(currency, can_purchase_credits, client_pays, markup_percentage)
    options = { :body => { 
      :Currency => currency,
      :CanPurchaseCredits => can_purchase_credits,
      :ClientPays => client_pays,
      :MarkupPercentage => markup_percentage }.to_json }
    put 'setmonthlybilling', options
  end

  def delete
    CreateSend.delete "/clients/#{client_id}.json", {}
  end

  private

  def get(action, options = {})
    CreateSend.get uri_for(action), options
  end

  def post(action, options = {})
    CreateSend.post uri_for(action), options
  end

  def put(action, options = {})
    CreateSend.put uri_for(action), options
  end

  def uri_for(action)
    "/clients/#{client_id}/#{action}.json"
  end
end