# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  namespace :api do
    resources :games, only: %i[] do
      member do
        post 'suggest_answer'
        post 'correct_answer'
        post 'incorrect_answer'
        post 'finish_question'
        post 'alarm'
      end
    end
  end

  namespace :admin do
    resources :teams
    resources :users, only: %i[index destroy]

    resources :games do
      resources :questions, only: %i[new create edit update destroy]

      resources :team_games, only: %i[new create destroy] do
        resources :game_players, only: %i[new create edit update destroy]
      end
    end
  end

  resources :pages, only: :index

  resources :games, only: %i[index show] do
    member do
      patch 'next_question'
      patch 'finish_question'
    end
  end

  resources :users, only: %i[new create show edit update index]

  resource :session, only: %i[new create destroy]

  root 'pages#index'
end
# rubocop:enable Metrics/BlockLength
