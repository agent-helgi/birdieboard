module Golf
  class RoundsController < BaseController
    def show
      @tournament = current_user.tournaments.find(params[:tournament_id])
      @round      = @tournament.rounds.find(params[:id])
      @my_score   = @round.scores.find_or_initialize_by(user: current_user)
      @all_scores = @round.scores.includes(:user).where(status: "approved")
                          .sort_by { |s| -(s.stableford_total || 0) }
    end
  end
end
