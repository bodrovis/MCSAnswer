import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    admin: Boolean
  }
  static targets = [ "answer", "total" ]

  connect() {
    this.calculateTotal()
  }

  answerTargetConnected(element) {
    this.calculateTotal()
    const actions = element.querySelector('.js-actions')

    if(actions) {
      if(this.adminValue) {
        actions.classList.remove('d-none')
      } else {
        actions.remove()
      }
    }
  }

  calculateTotal() {
    this.totalTarget.innerText = this.element.querySelectorAll('.js-correct').length;
  }
}