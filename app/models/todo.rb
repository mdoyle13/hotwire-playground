class Todo < ApplicationRecord
  validates :content, presence: true

  scope :complete, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: [false, nil]) }

  # after_create_commit -> { broadcast_prepend_to "todos" }
  # after_update_commit -> { broadcast_replace_to "todos" }
  # after_destroy_commit -> { broadcast_remove_to "todos" }
end
