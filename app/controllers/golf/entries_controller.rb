module Golf
  class EntriesController < BaseController
    before_action :set_tournament

    def new
      redirect_to golf_tournament_path(@tournament), notice: "Already entered." if already_entered?
      @entry = Entry.new(playing_handicap: whs_course_handicap)
    end

    def create
      redirect_to golf_tournament_path(@tournament), notice: "Already entered." if already_entered?

      # Recalculate from submitted handicap index in case they edited it
      round = @tournament.rounds.order(:day_number).first
      hc_index = entry_params[:playing_handicap].presence&.to_f || current_user.handicap_index.to_f
      calculated_hc = round ? round.course_handicap(hc_index) : hc_index.round

      @entry = @tournament.entries.new(
        entry_params.merge(user: current_user, playing_handicap: calculated_hc)
      )

      if @entry.save
        # Placeholder: when Stripe is wired up, redirect to Stripe Checkout here
        redirect_to golf_tournament_path(@tournament),
                    notice: "You're entered! Payment will be collected shortly."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_tournament
      @tournament = current_user.tournaments.find(params[:tournament_id])
    end

    def already_entered?
      @tournament.entries.exists?(user: current_user)
    end

    def whs_course_handicap
      round = @tournament.rounds.order(:day_number).first
      hc_index = current_user.handicap_index.to_f
      round ? round.course_handicap(hc_index) : hc_index.round
    end

    def entry_params
      params.require(:entry).permit(:playing_handicap, :team,
                                    :entered_cttp_front, :entered_cttp_back)
    end
  end
end
