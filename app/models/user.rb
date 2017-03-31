class User < ApplicationRecord
  #связываем юзера и сообщения (один юзер может иметь много сообщений)
  has_many :microposts, dependent: :destroy #при удалении пользователя, удаляются и сообщения
  has_many :active_relationships, class_name:  "Relationship", #связь пользователей (отношения фолловеры)
           foreign_key: "follower_id",
           dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship", #связь с подписчиками пользователя
           foreign_key: "followed_id",
           dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed #source показывает, что набором массива following будет набор идентификаторов followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token #добавляем токен активации
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: {minimum: 6 }, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

#Создает новый рандомный токен для пользователя
  def User.new_token
    SecureRandom.urlsafe_base64
  end

#Запоминает пользователя в бд для использования в постоянных сеансах.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Возвращает true, если токен соответствует дайджесту(хешированному токену)
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # сбрасывает ремембер диджест для выхода пользователя (забывает пользователя)
  def forget
    update_attribute(:remember_digest, nil)
  end

# Активация аккаунта
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
# Отправка письма для активации
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #Устанавливает атрибуты сброса пароля
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,    User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
# Отправка сброса пароля по емейлу
  def send_password_reset_email # здесь создается, а  вызывается в password_reset_controller'
    UserMailer.password_reset(self).deliver_now
  end

#возвращает true, если срок действия пароля истек
  def password_reset_expired?
    reset_sent_at < 2.hours.ago #если пароль отправлен раньше чем два часа назад
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

# Подписаться на пользователя
  def follow(other_user)
    following << other_user
  end

# Отписаться от пользователя
  def unfollow(other_user)
    following.delete(other_user)
  end

#возвращает true, если корректный юзер подписан на другого пользователя
  def following?(other_user)
    following.include?(other_user)
  end


  private

  def downcase_email
    self.email = email.downcase
  end
#Создает и присваивает токен активации и дайджест
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end