module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
# Запоминает пользователя в постоянном сеансе (браузер получает действительный remember token)
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id]) #если для пользователя есть сессия
    @current_user ||=User.find_by(id: session[:user_id]) #ищем пользователя во временной сессии
    elsif (user_id = cookies.signed[:user_id]) #если активной сессии для пользователя нет, то ищем куки юзера для входа

      user = User.find_by(id: user_id) #находим юзера по выбранному id
      if user && user.authenticated?(cookies[:remember_token])
        log_in user #вызываем помощник для входа юзера
        @current_user = user #назначаем нашего пользователя корректным полльзователем
        end
      end
  end

  def logged_in?
  !current_user.nil?
  end
#Забывает постоянный сеанс
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
