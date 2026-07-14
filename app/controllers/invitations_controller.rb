class InvitationsController < ApplicationController
  before_action :set_invitation

  # GET /invite/:token — show register/login form
  def show
    if @invitation.accepted?
      redirect_to golf_tournament_path(@invitation.tournament), notice: "You're already in."
    end
  end

  # POST /invite/:token — accept after login/register
  def accept
    unless user_signed_in?
      session[:pending_invitation_token] = params[:token]
      redirect_to new_user_registration_path and return
    end

    if @invitation.accepted?
      redirect_to golf_tournament_path(@invitation.tournament) and return
    end

    @invitation.accept!(current_user)
    redirect_to new_golf_tournament_entry_path(@invitation.tournament),
                notice: "Welcome to #{@invitation.tournament.name}! Complete your entry below."
  end

  private

  def set_invitation
    @invitation = Invitation.find_by!(token: params[:token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Invalid or expired invitation link."
  end
end
