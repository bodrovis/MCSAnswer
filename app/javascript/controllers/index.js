// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import GamesController from "./games_controller"
application.register("games", GamesController)

import RedirectController from "./redirect_controller";
application.register("redirect", RedirectController)

import ResetFormController from "./reset_form_controller";
application.register("reset-form", ResetFormController)

import Recaptchav2Controller from "./recaptcha_v2_controller";
application.register("recaptcha-v2", Recaptchav2Controller)