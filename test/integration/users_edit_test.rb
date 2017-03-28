require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
#устанавляваем значение переменной юзер
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end


  test "successful edit with friendly forwarding" do
    get edit_user_path(@user) #переходим на страницу редактирования
    log_in_as(@user) # затем входим в систему
    assert_redirected_to edit_user_url(@user) #пользователь перенаправляется на страницу редактирования
    #get edit_user_path(@user) #переходим на страницу редактирования юзера
    assert_template 'user/edit' #проверяем, что отображается нужная страница редактирования
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, #отправляем верные данные для редактирования
                                              email: email,
                                              password: "",
                                              password_confirmation: ""} }
    assert_not flash.empty?
    assert_redirected_to @user #при успешном изменении данных, перенаправление на страницу юзера
    @user.reload #перезагружаем данные о юзере в бд
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
