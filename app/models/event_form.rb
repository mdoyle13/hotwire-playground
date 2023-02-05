class EventForm
  include ActiveModel::Model

  STEPS = {
    name: %i[name],
    description: %i[description],
    time: %i[starts_at ends_at]
  }.freeze
  
  attr_accessor :current_step, :name, :description, :starts_at, :ends_at

  with_options if: -> { required_for_step?(:name) } do
  end

  with_options if: -> { required_for_step?(:description) } do
  end

  with_options if: -> { required_for_step?(:time) } do
  end

  def self.steps
    STEPS
  end

  def save
    if valid?
      Event.create!(name: name, description: description, starts_at: starts_at, ends_at: ends_at)
    else
      false
    end
  end

  private
  
  def required_for_step?(step)
    # All fields required 
    return true unless current_step.present?

    # if the index of passed in :step is lower than or equal to
    # the current step of the form object then the "required for step"
    # is true
    ordered_step_keys = self.class.steps.keys
    ordered_step_keys.index(step) <= ordered_steps.index(current_step)
  end
end