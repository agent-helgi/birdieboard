module Admin
  class TournamentsController < BaseController
    before_action :require_organiser!
    before_action :set_tournament, only: %i[show edit update destroy open close]

    def index
      @tournaments = current_user.organised_tournaments.order(date: :desc)
    end

    def show
      @entries = @tournament.entries.includes(:user).order("users.name")
      @rounds  = @tournament.rounds.order(:day_number)
    end

    def new
      @tournament = Tournament.new(
        entry_fee_pence: 1000,
        cttp_fee_pence: 500,
        format: "stableford",
        state: "draft"
      )
    end

    def create
      @tournament = current_user.organised_tournaments.new(tournament_params)
      if @tournament.save
        redirect_to admin_tournament_path(@tournament), notice: "Tournament created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @tournament.update(tournament_params)
        redirect_to admin_tournament_path(@tournament), notice: "Updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @tournament.destroy
      redirect_to admin_tournaments_path, notice: "Deleted."
    end

    def open
      @tournament.update!(state: "open")
      redirect_to admin_tournament_path(@tournament), notice: "Tournament is now open for entries."
    end

    def close
      @tournament.update!(state: "closed")
      redirect_to admin_tournament_path(@tournament), notice: "Tournament closed."
    end

    private

    def set_tournament
      @tournament = current_user.organised_tournaments.find(params[:id])
    end

    def tournament_params
      params.require(:tournament).permit(
        :name, :location, :date, :format, :state,
        :team1_name, :team2_name, :team_trophy, :individual_trophy,
        :entry_fee_pence, :cttp_fee_pence, :notes
      )
    end

    def require_organiser!
      redirect_to admin_root_path, alert: "Not authorised." unless current_user.organiser?
    end
  end
end
