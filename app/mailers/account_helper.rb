class AccountHelper < ActionMailer::Base
  default from: Myaka::Application.config.support_mail_from
  
  def forgot_password(password_reset, key)
    @reset = password_reset
    @key = key
    mail to: password_reset.aka.email, subject: 'Your password reset link.'
  end
  
  def forgot_akas(email_address)
    @email = email_address
    @akas = Aka.where(email:email_address)
    mail to: email_address, subject: 'Your forgotten AKAs.'
  end

end
