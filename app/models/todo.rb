class Todo < ApplicationRecord
  validates :content, presence: true
end
