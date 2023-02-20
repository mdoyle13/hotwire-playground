require "test_helper"

class EventBuilderFormTest < ActiveSupport::TestCase
  test "all attributes are required if current_step attribute is missing" do
    event_builder = EventBuilderForm.new
    assert_not event_builder.valid?

    error_keys = event_builder.errors.messages.keys

    EventBuilderForm.steps.each do |step, attributes|
      attributes.each do |attribute|
        assert error_keys.include? attribute
      end
    end
  end

  test "name is required on name step" do
    event_builder = EventBuilderForm.new(current_step: :name)
    assert_not event_builder.valid?
    assert_equal *event_builder.errors.messages.keys, :name
  end
  
  test "description is required on description step" do
    event_builder = EventBuilderForm.new(name: "My Event", current_step: :description)
    assert_not event_builder.valid?
    assert_equal *event_builder.errors.messages.keys, :description
  end

  test "starts_at and ends_at are required on time step" do
    event_builder = EventBuilderForm.new(
      name: "My Event",
      description: "a great event!",
      current_step: :time
    )

    assert_not event_builder.valid?

    %i[starts_at ends_at].each do |attr|
      assert event_builder.errors.messages.keys.include?(attr)
    end
  end
end
