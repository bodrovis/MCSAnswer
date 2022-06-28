import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    admin: Boolean
  }
  static targets = [ "answer", "total" ]

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
    if(this.element.querySelector('.js-place').innerText.length > 0) { return }
    this.totalTarget.innerText = `(${this.element.querySelectorAll('.js-correct').length})`;
  }
}