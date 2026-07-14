module Admin
  class RoundsController < BaseController
    before_action :set_tournament

    def new
      @round = @tournament.rounds.new(format: @tournament.format)
    end

    def create
      @round = @tournament.rounds.new(round_params)
      if @round.save
        redirect_to admin_tournament_path(@tournament), notice: "Round #{@round.day_number} added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @round = @tournament.rounds.find(params[:id])
    end

    def update
      @round = @tournament.rounds.find(params[:id])
      if @round.update(round_params)
        redirect_to admin_tournament_path(@tournament), notice: "Round updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_tournament
      @tournament = current_user.organised_tournaments.find(params[:tournament_id])
    end

    def round_params
      p = params.require(:round).permit(:day_number, :course_name, :format,
                                        course_par: [], course_si: [])
      p[:course_par] = p[:course_par].map(&:to_i) if p[:course_par]
      p[:course_si]  = p[:course_si].map(&:to_i)  if p[:course_si]
      p
    end
  end
end
