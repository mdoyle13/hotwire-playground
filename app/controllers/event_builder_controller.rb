class EventBuilderController < ApplicationController
  include Wicked::Wizard
  steps *EventForm.steps.keys

  def show
    # hydrate event from the session
    session[:event_attrs] ||= {}
    event_attrs = session[:event_attrs]
    @event = EventForm.new(event_attrs)
    render_wizard
  end

  def update
    event_attrs = session[:event_attrs].merge(event_params)
    @event = EventForm.new(event_attrs)
    if @event.valid?
      session[:event_attrs] = event_attrs
      redirect_to_next next_step
    else
      render_wizard @event
    end
  end

  def finish_wizard_path
    @event = Event.create!(session[:event_attrs].except("current_step"))
    session[:event_attrs] = nil
    event_path(@event)
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :starts_at, :ends_at).merge(current_step: step)
  end
end
