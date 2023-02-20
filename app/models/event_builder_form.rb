class EventBuilderForm
  include ActiveModel::Model

  STEPS = {
    name: %i[name],
    description: %i[description],
    time: %i[starts_at ends_at]
  }.freeze
  
  attr_accessor :current_step, :name, :description, :starts_at, :ends_at

  with_options if: -> { required_for_step?(:name) } do
    validates :name, presence: true
  end

  with_options if: -> { required_for_step?(:description) } do
    validates :description, presence: true
  end

  with_options if: -> { required_for_step?(:time) } do
    validates :starts_at, :ends_at, presence: true
  end

  def self.steps
    STEPS
  end

  # render_wizard calls save on this object
  # return true or false tells Wicked what to do with the response
  def save
    if valid?
      true
    else
      false
    end
  end

  private
  
  # step param is a symbol
  def required_for_step?(step)
    # All fields required if current_step attr is missing
    return true unless current_step.present?

    # if the index of passed in the passed instep is lower than or equal to
    # the current step of the form object then the "required for step"
    # is true
    ordered_step_keys = self.class.steps.keys
    ordered_step_keys.index(step) <= ordered_step_keys.index(current_step)
  end
end