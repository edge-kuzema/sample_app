class UserMailer < ApplicationMailer

#Отправляется ссылка на почту юзера для активации аккаунта пользователя
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
