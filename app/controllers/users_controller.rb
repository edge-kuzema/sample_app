class UsersController < ApplicationController

before_action :logged_in_user, only: [:index, :edit, :update, :destroy] #вызывает конкретный метод первее других
before_action :correct_user, only: [:edit, :update]
before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page]) #метод вытягивает пользователей по 30 штук(по умолчанию) за раз, те страница 1: 1-30 пользователь
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page]) #добавление переменной микропост для дейтсвия отображения
  end


  def new
  @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email #отправка емейла активации через модель пользователя
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url #перенаправление в корневой каталог вместо страницы пользователя
      #log_in @user
      #flash[:success] = "Welcome to the Sample App!"
      #redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

def destroy
  User.find(params[:id]).destroy
  flash[:success] = "User deleted"
  redirect_to users_url
end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end

#перенесен в аппликейшн котроллер, потому что метод вызывается в обоих контроллерах
#def logged_in_user #подтверждает вошедшего в систему пользователя
  #unless logged_in? #Если только залогинились, тогда доступны действия редактирования
  #  store_location #вызывает помощник из sessions_helper
   # flash[:danger] = "Please log in."
    #redirect_to login_url
 # end
#end

def correct_user
  @user = User.find(params[:id])
  redirect_to(root_url) unless current_user?(@user)
end
#подтверждает пользователя админ (т.е только админ может видеть и использовать дестрой)
def admin_user
  redirect_to(root_url) unless current_user.admin?
end