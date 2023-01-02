# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  namespace :admin do
    resources :achievements, only: %i[index new create show destroy]
    resources :achievement_ownables, only: %i[new create]

    resources :teams
    resources :users, only: %i[index destroy]

    resources :games do
      member do
        patch 'reorder_questions'
      end

      resources :questions, only: %i[new create edit update destroy]

      resources :playing_teams, only: %i[new create destroy] do
        resources :game_players, only: %i[new create edit update destroy]
      end
    end
  end

  resources :pages, only: :index do
    collection do
      get 'search'
    end
  end

  resources :games, only: %i[index show] do
    member do
      patch 'recalculate'
      patch 'fill_empty'
    end

    resources :playing_teams, only: %i[index]

    resources :answers, only: %i[index create edit update] do
      member do
        patch 'toggle'
      end
    end

    resources :questions, only: %i[index]
  end

  resources :game_actions, only: %i[] do
    member do
      patch 'next_question'
      patch 'start_question'
      patch 'finish_question'
      patch 'answer_question'
    end
  end

  resources :users, only: %i[new create show edit update index]

  resources :teams, only: %i[index show]

  resource :session, only: %i[new create destroy]

  root 'pages#index'
end
# rubocop:enable Metrics/BlockLength
