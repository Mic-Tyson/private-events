class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @events = Event.all
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      @event.attendees << current_user
      redirect_to @event, notice: 'Event was saved'
    else
      flash.now[:error] = @event.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find params[:id]
  end

  def new
    @event = Event.new
  end

  def rsvp
    @event = Event.find(params[:id])
    if user_signed_in?
      if @event.attendees.include?(current_user)
        redirect_to @event, alert: 'You have already RSVP\'d to this event.'
      else
        @event.attendees << current_user
        redirect_to @event, notice: 'You have successfully RSVP\'d to the event.'
      end
    else
      session[:user_return_to] = request.fullpath
      Rails.logger.debug "Storing RSVP path: #{request.fullpath}"
    end
  end

  def remove_rsvp
    @event = Event.find(params[:id])
    return unless @event.attendees.include?(current_user)

    @event.attendees.delete(current_user)
    redirect_to @event, notice: 'You have successfully cancelled your RSVP.'
  end

  def edit
    @event = Event.find params[:id]
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def delete
    @event = Event.find(params[:id])
    if @event.destroy
      redirect_to events_path, notice: 'Event was successfully deleted.'
    else
      flash.now[:error] = @event.errors.full_messages.to_sentence
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :date)
  end
end
