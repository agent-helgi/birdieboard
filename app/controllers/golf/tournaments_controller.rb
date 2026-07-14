module Golf
  class TournamentsController < BaseController
    def index
      @tournaments = current_user.tournaments
                                 .merge(Tournament.open_to_entries)
                                 .order(date: :asc)
    end

    def show
      @tournament = current_user.tournaments.find(params[:id])
      @entry      = @tournament.entries.find_by(user: current_user)
      @rounds     = @tournament.rounds.order(:day_number)
    end
  end
end
