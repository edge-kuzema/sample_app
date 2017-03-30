require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  #создаем новый микропост, привязывая его к конкретному пользователю из фикстур
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  #тут проверяем, что результат привязывания сообщения к юзеру действительный
  test "should be valid" do
    assert @micropost.valid?
  end

  #проверка того, что пользователь существует
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
 #Проверка того, что микропост существует
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end
#проверка того, что сообщение не больше 140 символов
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # проверка порядка вывода микропостов (самое последнее должно быть вначале)
  # проверка того, что первое микросообщение в базе совпадает с фикстурным микросообщением
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
