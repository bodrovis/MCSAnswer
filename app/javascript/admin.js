// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"

import { Dropdown, Collapse } from 'bootstrap'

import { application } from "./controllers/application"

import SortableController from "./controllers/admin/sortable_controller";
application.register("sortable", SortableController)

import ResetFormController from "./controllers/admin/reset_form_controller";
application.register("reset-form", ResetFormController)