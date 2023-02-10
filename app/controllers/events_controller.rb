class EventsController < ApplicationController
  def new
    @event = Event.new.save(validate: false)
    redirect_to event_builder_path(id: EventForm.steps.keys.first)
  end

  def index
  end
end
