import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    admin: Boolean
  }
  static targets = [ "answer" ]

  answerTargetConnected(element) {
    const actions = element.querySelector('.js-actions')

    if(actions) {
      if(this.adminValue) {
        actions.classList.remove('d-none')
      } else {
        actions.remove()
      }
    }
  }
}