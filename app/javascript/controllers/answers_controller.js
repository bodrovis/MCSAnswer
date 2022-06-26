import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "answerForm" ]

  async toggleForm({ detail: { show } }) {
    if(show) {
      this.answerFormTarget.classList.remove('d-none')
    } else {
      this.answerFormTarget.classList.add('d-none')
      await this.doPost(
        `/games/${this.answerFormTarget.querySelector('#game_id').value}/answers`,
        new FormData(this.answerFormTarget)
      )
      
      this.answerFormTarget.reset()
    }
  }

  async doPost(url, body) {
    const csrfToken = document.getElementsByName("csrf-token")[0].content;
    try {
      const resp = await fetch(url, {
        method: 'POST',
        body: body,
        headers: {
          "X-CSRF-Token": csrfToken
        }
      })
      if(resp.status > 299) {
        throw new Error(`Can't send answer: HTTP ${resp.status}`)
      }
    } catch(e) {
      console.error(e)
    }
  }
}