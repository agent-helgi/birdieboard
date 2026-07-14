module Admin
  class EntriesController < BaseController
    before_action :set_tournament

    def index
      @entries = @tournament.entries.includes(:user).order("users.name")
    end

    private

    def set_tournament
      @tournament = current_user.organised_tournaments.find(params[:tournament_id])
    end
  end
end
