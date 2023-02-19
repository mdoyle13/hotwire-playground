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
    if @event.valid?
      session[:event_attrs] = event_attrs
      redirect_to_next next_step
    else
      # note: wicked is calling "save" on @event when render_wizard is run
      render_wizard @event
    end
  end

  # Wicked calls this method after the last step of the form is successful
  # Return a path/url after performing a few cleanup steps
  def finish_wizard_path
    Event.create!(session[:event_attrs].except("current_step"))

    # reset event_attrs in session
    session[:event_attrs] = nil

    # return event_path for redirect
    events_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :starts_at, :ends_at).merge(current_step: step)
  end
end
