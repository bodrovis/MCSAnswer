module Admin
  class TeamsController < BaseController
    before_action :set_team!, only: %i[destroy edit update show]
    before_action :authorize_team!
    after_action :verify_authorized

    def index
      @teams = Team.order created_at: :desc
    end

    def new
      @team = Team.new
    end

    def create
      @team = Team.new team_params

      if @team.save
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = t('.success')
          end
        end
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @team.update team_params
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = t('.success')
            @path = admin_team_path(@team)
          end
        end
      else
        render :new
      end
    end

    def destroy
      @team.destroy

      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = t('.success')
        end
      end
    end

    private

    def set_team!
      @team = Team.find params[:id]
    end

    def authorize_team!
      authorize(@team || Team)
    end

    def team_params
      params.require(:team).permit(:title)
    end
  end
end