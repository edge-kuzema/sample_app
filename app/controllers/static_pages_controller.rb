class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build #писать сообщения может только залогиненный пользователь
      @feed_items = current_user.feed.paginate(page: params[:page]) #отображает рядом все сообщения юзера
    end
  end

  def help
  end

  def about
  end
end
