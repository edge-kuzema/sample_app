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

  #Возвращает true, если пользователь является текущим пользователем
  def current_user?(user)
    user == current_user
  end

  #def current_user
  #if (user_id = session[:user_id]) #если для пользователя есть сессия
  #  @current_user ||=User.find_by(id: session[:user_id]) #ищем пользователя во временной сессии
   # elsif (user_id = cookies.signed[:user_id]) #если активной сессии для пользователя нет, то ищем куки юзера для входа
    #  user = User.find_by(id: user_id) #находим юзера по выбранному id
   #   if user && user.authenticated?(:remember, cookies[:remember_token])
    #    log_in user #вызываем помощник для входа юзера
      #  @current_user = user #назначаем нашего пользователя корректным полльзователем
    #    end
     # end
  #end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
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

#Чтобы перенаправить пользователей в их предназначение, нам нужно где-нибудь сохранить местоположение запрашиваемой страницы, а затем перенаправить его на это место вместо значения по умолчанию.
# перенаправление на сохраненное местоположение (или по умолчанию)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
  end

  def store_location #сохраняет URL-адрес, который пытается получить доступ
    session[:forwarding_url] = request.original_url if request.get? #получаем URL запрошенной страницы
  end
end
