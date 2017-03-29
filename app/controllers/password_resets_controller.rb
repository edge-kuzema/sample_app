class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] #вызывает метод проверки того, что пароль не просрочен

  def new
  end

  #находим пользователя по адресу электронной почты и обновляем его атрибуты
  # маркером сброса пароля и отметкой времени отправки.
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest #создаем дайджест сброса пароля
      @user.send_password_reset_email #отправляем пользователю на почту
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url #перенаправляем на главную страницу
    else
      flash.now[:danger] = "Email adress not found"
      render 'new' #повторно визуализируем страницу
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # Case (2)
    end
  end

  private
def user_params
  params.require(:user).permit(:password, :password_confirmation)
end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  #проверка того, что пользователь существует, активирован и аутентифицирован
  def valid_user
    unless (@user && @user.activated? &&
        @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  #Проверяет истечение срока действия токена сброса
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end

end
