class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  validates :title, length:{in: 6..255}
  validates :body, length:{minimum: 6}
end
