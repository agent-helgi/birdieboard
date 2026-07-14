class Users::RegistrationsController < Devise::RegistrationsController
  layout :pick_layout

  before_action :set_invite, only: %i[new create]

  def new
    super
  end

  def create
    super do |user|
      if user.persisted? && @invite_token.present?
        invitation = Invitation.find_by(token: @invite_token)
        if invitation && invitation.pending?
          invitation.accept!(user)
          session.delete(:pending_invitation_token)
          # Override the Devise redirect
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, user)
          redirect_to new_golf_tournament_entry_path(invitation.tournament),
                      notice: "Welcome to BirdieBoard! Complete your entry below." and return
        end
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :email, :password, :password_confirmation,
      :name, :surname, :phone, :cdh_number, :handicap_index
    )
  end

  def set_invite
    @invite_token = params[:invite] || session[:pending_invitation_token]
    @invitation   = Invitation.find_by(token: @invite_token) if @invite_token.present?
    session[:pending_invitation_token] = @invite_token if @invite_token.present?
  end

  def pick_layout
    @invite_token.present? ? "golf_auth" : "devise"
  end
end
