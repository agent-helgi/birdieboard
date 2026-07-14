class Users::SessionsController < Devise::SessionsController
  layout :pick_layout

  before_action :stash_invite_in_session, only: %i[new create]
  after_action  :handle_pending_invite,   only: :create

  private

  def handle_pending_invite
    return unless user_signed_in?

    token = session[:pending_invitation_token] || params[:invite]
    return unless token.present?

    invitation = Invitation.find_by(token: token)
    return unless invitation&.pending?

    invitation.accept!(current_user)
    session.delete(:pending_invitation_token)

    # Check if they need to enter the tournament
    unless invitation.tournament.entries.exists?(user: current_user)
      redirect_to new_golf_tournament_entry_path(invitation.tournament),
                  notice: "Welcome back! Complete your entry for #{invitation.tournament.name}."
    end
  end

  def stash_invite_in_session
    session[:pending_invitation_token] = params[:invite] if params[:invite].present?
  end

  def pick_layout
    (params[:invite].present? || session[:pending_invitation_token].present?) ? "golf_auth" : "devise"
  end
end
