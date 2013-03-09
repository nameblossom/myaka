module SessionsHelper
  def sign_in(aka)
    reset_session
    session[:signed_in_as] = aka.id
    self.current_aka = aka
  end

  def signed_in?
    !current_aka.nil?
  end

  def current_aka=(aka)
    @current_aka = aka
  end

  def current_aka
    @current_aka ||= Aka.find_by_id(session[:signed_in_as])
  end

  def sign_out
    @current_aka = nil
    reset_session
  end

end
