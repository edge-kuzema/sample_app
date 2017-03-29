# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation #требуется допустимый объект пользователя
    user = User.first    #определяем переменную юзера, равную первому пользователю
    user.activation_token = User.new_token #присваивается значение токена активации
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token #присваивается значение токена сброса пароля
    UserMailer.password_reset(user)
  end
  end

