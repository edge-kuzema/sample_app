class UserMailer < ApplicationMailer

#Отправка ссылки на почту юзера для активации аккаунта пользователя
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end
# Отправка ссылки на почту юзера для сброса пароля
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
