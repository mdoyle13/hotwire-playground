class EventsController < ApplicationController
  def new
  end

  def index
    @events = Event.all.limit(10)
  end
end
