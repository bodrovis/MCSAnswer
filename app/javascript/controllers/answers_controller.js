import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "answerForm" ]

  async toggleForm({ detail: { show } }) {
    if(show) {
      this.answerFormTarget.classList.remove('d-none')
    } else {
      this.answerFormTarget.classList.add('d-none')
      try {
        await this.doPost(
          `/games/${this.answerFormTarget.querySelector('#game_id').value}/answers`,
          new FormData(this.answerFormTarget)
        )
      } catch(e) {
        console.error(e)
      }
      
      this.answerFormTarget.reset()
    }
  }

  async doPost(url, body) {
    const csrfToken = document.getElementsByName("csrf-token")[0].content;
    await fetch(url, {
      method: 'POST',
      body: body,
      headers: {
        "X-CSRF-Token": csrfToken
      }
    })
  }
}