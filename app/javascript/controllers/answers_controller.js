import { Controller } from "@hotwired/stimulus"
import { post } from '@rails/request.js'

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
      } catch (e) {
        console.log(e)
      }
      
      this.answerFormTarget.reset()
    }
  }

  async doPost(url, body) {
    const response = await post(url, { body: body, responseKind: 'turbo-stream' })

    if (!response.ok) {
      throw new Error(`Can't send answer: HTTP ${response.statusCode}`)
    }
  }
}