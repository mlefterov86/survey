class PollsController < ApplicationController
  before_action :poll, only: %i[show submit]

  def show
    # render poll
  end

  def submit

  end

  private

  def poll
    @poll ||= Poll.find(params[:id])
  end
end
