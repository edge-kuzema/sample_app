class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      #remember user #вызов хелпера, который запоминает пользователя при входе
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) #если флажок запомнить меня выставлен, то запоминаем юзера
      #заменяет if-else
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  #Позволяет закрывать сессию, только если пользователь залогиненный (чтобы при закрытии второго окна в браузере не возникало ошибки)
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
