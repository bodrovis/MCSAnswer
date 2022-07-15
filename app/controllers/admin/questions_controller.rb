# frozen_string_literal: true

module Admin
  class QuestionsController < BaseController
    before_action :find_game!
    before_action :find_question!, except: %i[new create]
    after_action :verify_authorized

    def new
      authorize Question
      @question = @game.build_next_question
    end

    def create
      @question = @game.questions.build question_params

      authorize @question

      if @question.save
        @new_question = @game.build_next_question
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = t('.success')
          end
        end
      else
        render :new
      end
    end

    def edit
      authorize @question
    end

    def update
      authorize @question

      if @question.update question_params
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = t('.success')
          end
        end
      else
        render :edit
      end
    end

    def destroy
      authorize @question

      @question.destroy

      respond_to do |format|
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    end

    private

    def find_game!
      @game = Game.find params[:game_id]
    end

    def find_question!
      @question = @game.questions.find params[:id]
    end

    def question_params
      params.require(:question).permit(:body, :answer, :position, :current, :answered)
    end
  end
end
