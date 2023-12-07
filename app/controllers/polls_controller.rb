# frozen_string_literal: true

class PollsController < ApplicationController
  before_action :poll, :questions, :customer, only: %i[show vote]

  def show
    render 'polls/not_found' and return unless poll

    # questions
  end

  def vote
    redirect_to poll_path(@poll) and return unless permitted_params[:question_id]

    ActiveRecord::Base.transaction do
      customer = Customer.find_or_create_by!(ip: request.remote_ip)
      Vote.create!(customer:, poll_id: permitted_params[:id], question_id: permitted_params[:question_id])
    end

    redirect_to poll_path(@poll)
  end

  private

  def permitted_params
    params.permit(:id, :question_id)
  end

  def poll
    @poll ||= Poll.find_by_id(params[:id]).published.first
  end

  def questions
    @questions ||= Poll.questions_for(poll)
  end

  def customer
    @customer ||= Customer.find_by(ip: request.remote_ip)
  end
end
