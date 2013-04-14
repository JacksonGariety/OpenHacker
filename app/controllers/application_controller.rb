class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate

private

  def current_user
    @user = User.find(cookies[:user_id]) if cookies[:user_id]
  end

  def is_moderator(user)
	  user = User.find(cookies[:user_id]) if cookies[:user_id]

    user.ribbon_array ||= []
    user.ribbon_array.include?(1) ? true : false
	end

	def is_banned(user)
		@is_banned = Time.now - user.banned_at < 7 unless user.baned_at.nil? ? true : false
	end

  def current_open_challenge
    Challenge.find_by_status(2)
  end

  def current_voting_challenge
    Challenge.find_by_status(3)
  end

  def current_closed_challenge
    Challenge.find_by_status(4)
  end

  def next_entry
    entries = (Entry.all.collect(&:id) - current_user.votes.collect(&:entry_id)).sample
    unless entries.nil?
      Entry.find(entries)
    else
      current_voting_challenge
    end
  end

  helper_method :current_user, :is_moderator, :current_open_challenge, :current_voting_challenge, :current_closed_challenge, :next_entry

  def authenticate
    redirect_to "/auth/github" unless current_user
  end
end