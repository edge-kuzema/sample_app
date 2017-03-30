require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end


  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name) #проверяем название страницы
    assert_select 'h1', text: @user.name #имя пользователя
    assert_select 'h1>img.gravatar' #проверяем, что отображается Gravatar
    assert_match @user.microposts.count.to_s, response.body #проверяет, что количество микросообщений появляется где-то на странице
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost| #проверяется, что происходит разбивка сообщений по страницам
      assert_match micropost.content, response.body
    end
  end
end