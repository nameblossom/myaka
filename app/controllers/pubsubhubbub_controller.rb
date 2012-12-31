require 'rest_client'

class PubsubhubbubController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def register
    @callback_url = params['hub.callback']    
  end

  def info

  end
end
