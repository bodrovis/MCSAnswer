import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "alert" ]

  reset() {
    this.element.reset()
    if(this.hasAlertTarget) {
      this.alertTarget.remove()
    }
  }
}