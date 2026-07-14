module Admin
  class InvitationsController < BaseController
    before_action :set_tournament

    def index
      @invitations = @tournament.invitations.includes(:user).order(:email)
    end

    def new
      @invitation = @tournament.invitations.new
    end

    def create
      emails = invitation_params[:emails].to_s.split(/[\s,]+/).map(&:strip).select(&:present?)

      created = 0
      emails.each do |email|
        inv = @tournament.invitations.find_or_initialize_by(email: email.downcase)
        if inv.new_record?
          inv.save!
          InvitationMailer.invite(inv).deliver_later
          created += 1
        end
      end

      redirect_to admin_tournament_invitations_path(@tournament),
                  notice: "#{created} invitation(s) sent."
    end

    def destroy
      @tournament.invitations.find(params[:id]).destroy
      redirect_to admin_tournament_invitations_path(@tournament), notice: "Invitation removed."
    end

    private

    def set_tournament
      @tournament = current_user.organised_tournaments.find(params[:tournament_id])
    end

    def invitation_params
      params.require(:invitation).permit(:emails)
    end
  end
end
