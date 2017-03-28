require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
    post user_path, params: { user: { name: "Olga",
    email: "olgakovaleva@mail.com",
     password: "123456789",
     password_confirmation: "123456789" }}
  end
    assert_equal 1, ActionMailer::Base.deliveries.size #тут проверяется, что было доставлено ровно одно сообщение
    user = assigns(:user)
    assert_not user.activated?
    #Попытка войти в систему перед активацией
    log_in_as(user)
    assert_not is_logged_in?
    #Неправильный токен активации
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Правильный токин, неверный емейл
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Правильный токен активации
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end