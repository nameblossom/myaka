require 'digest'
require 'digest/hmac'
class MailingListController < ApplicationController

  def unsubscribe
    email = params[:email]
    hmac_sha1 = params[:hmac_sha1]
    if email and hmac_sha1 and hmac_sha1 == Digest::HMAC.hexdigest(email, Myaka::Application.config.secret_token, Digest::SHA1)
      Aka.update_all({keep_me_updated:false}, {email:email})
      @message = "#{email} has been unsubscribed. You may still get important system notifications."
    else
      @message = "There was a problem verifying the unsubscribe code. If you are having trouble you may contact paul@aka.nu for assistance."
    end
  end

end
