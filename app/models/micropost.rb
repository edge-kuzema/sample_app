class Micropost < ApplicationRecord
  belongs_to :user #указывает, что сообщение принадлежит пользователю
  default_scope -> { order(created_at: :desc) } #порядок вывода микросообщений (самые поздние вначалеra)
  mount_uploader :picture, PictureUploader #загрузчик, ассоциирует изображение с микропостом
  validates :user_id, presence: true #проверка наличия пользователя
  validates :content, presence: true,  length: { maximum: 140 } #проверка наличия микропоста и его длины
  validate  :picture_size #устанавливает ограничение на размер изображения


  # Проверяет размер загружаемого изображения
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

end
