module SessionsHelper

  def login(user)
    session[:id] = user.id
    flash[:notice] = "#{user.name} logged in"
  end

  def logout(user)
    session.delete :id
    forget user
  end

  def remember(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_me
  end

  def forget(user)
    cookies.delete :user_id
    cookies.delete :remember_token
    user.forget_me
  end

  def current_user
    user = User.find_by_id(session[:id])
    unless user
      user = User.find_by_id(cookies.signed[:user_id])
      remember_digest = User.digest(cookies.signed[:remember_token])
      if user && remember_digest && remember_digest == user&.remember_digest
        login user
      else
        user = nil
      end
    end
    return user
  end

  def logged_in?(user)
    session[:id] == user.id if user
  end
end
