module Golf
  class ScoresController < BaseController
    before_action :set_tournament_and_round
    before_action :set_score, only: %i[edit update submit approve]

    def new
      @score = @round.scores.find_or_initialize_by(user: current_user)
    end

    def create
      @score = @round.scores.find_or_initialize_by(user: current_user)
      if @score.update(score_params)
        redirect_to golf_tournament_round_path(@tournament, @round),
                    notice: "Scores saved."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @score.update(score_params)
        redirect_to golf_tournament_round_path(@tournament, @round), notice: "Scores updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # Player submits their card → triggers partner notification
    def submit
      @score.submit!
      notify_partner_for_approval(@score)
      redirect_to golf_tournament_round_path(@tournament, @round),
                  notice: "Scorecard submitted. Your partner will be asked to countersign."
    end

    # Partner approves the card
    def approve
      target_score = @round.scores.find(params[:id])

      # Must be the playing partner (same round, different user, paid entry)
      unless partner_of?(target_score)
        redirect_to golf_tournament_path(@tournament), alert: "Not authorised." and return
      end

      target_score.approve!(current_user)
      redirect_to golf_tournament_round_path(@tournament, @round),
                  notice: "Scorecard countersigned."
    end

    private

    def set_tournament_and_round
      @tournament = current_user.tournaments.find(params[:tournament_id])
      @round      = @tournament.rounds.find(params[:round_id])
    end

    def set_score
      @score = @round.scores.find(params[:id])
    end

    def score_params
      p = params.require(:score).permit(gross_scores: [])
      p[:gross_scores] = p[:gross_scores].map { |s| s.blank? ? nil : s.to_i }
      p
    end

    def partner_of?(score)
      # For now: any other entered player in the same round can approve
      score.user != current_user &&
        @tournament.entries.exists?(user: current_user)
    end

    def notify_partner_for_approval(score)
      # TODO: wire up mailer / push notification when partner approval is built
    end
  end
end
