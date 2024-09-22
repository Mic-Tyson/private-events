class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @events = Event.all
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      event_user = @event.events_users.find_or_initialize_by(user_id: current_user.id)
      event_user.confirmed!
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
    return if @event.confirmed_users.include?(current_user)

    event_user = @event.events_users.find_or_initialize_by(user_id: current_user.id)
    event_user.confirmed!
    redirect_to @event, notice: 'You have successfully RSVP\'d to the event.'
  end

  def remove_rsvp
    @event = Event.find(params[:id])
    return unless @event.confirmed_users.include?(current_user)

    @event.attendees.destroy(current_user)
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

  def invite
    @event = Event.find(params[:id])
    @user = User.find(params[:query])

    events_user = @event.events_users.find_by(user: @user)

    if events_user && (events_user.invited || events_user.confirmed)
      redirect_to @event, alert: 'User has already been invited to the event.'
    else
      @event.attendees << @user
      redirect_to @event, notice: 'User has been successfully invited to the event.'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to @event, alert: 'User or event not found.'
  end

  def confirmed_attendees
    attendees.joins(:events_users).merge(EventsUser.confirmed)
  end

  private

  def event_params
    params.require(:event).permit(:title, :date)
  end
end
