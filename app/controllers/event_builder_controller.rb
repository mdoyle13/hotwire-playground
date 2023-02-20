class EventBuilderController < ApplicationController
  include Wicked::Wizard
  
  steps *EventBuilderForm.steps.keys

  def show
    # hydrate event data from the session, if any exists
    session[:event_attrs] ||= {}
    event_attrs = session[:event_attrs]
    @event = EventBuilderForm.new(event_attrs)
    render_wizard
  end

  def update
    event_attrs = session[:event_attrs].merge(event_params)

    @event = EventBuilderForm.new(event_attrs)
    session[:event_attrs] = event_attrs

    # render_wizard calls save on the @event object
    # if save returns true, the next step is rendered,
    # otherwise the current step is rendered
    render_wizard @event
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :starts_at, :ends_at).merge(current_step: step)
  end

  # this method is called after the last step is successful
  # Returns a path/url after performing a few cleanup steps
  def finish_wizard_path
    # save the event to the database using valid attributes from session
    event_attrs = session[:event_attrs].except("current_step")
    Event.create!(event_attrs)

    # reset event_attrs in session
    session[:event_attrs] = nil

    # return event_path for redirect
    events_path
  end
end
