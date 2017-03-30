class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url # с помощью request.referrer мы организуем перенаправление на страницу, отправляющую запрос на удаление на обеих страницах (главной и конкретно в сообщениях).
  end

  private

  def micropost_params
   params.require(:micropost).permit(:content, :picture) #добавляем изображение в список атрибутов, разрешенных для изменения через Интернет.
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end