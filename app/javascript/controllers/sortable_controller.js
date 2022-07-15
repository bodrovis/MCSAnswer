import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = {
    game: String
  }

  connect() {
    const gameId = this.gameValue

    new Sortable(this.element, {
      onEnd: async function(e) {
        const response = await patch(`/admin/games/${gameId}/reorder_questions`, { body: JSON.stringify({"new_index": e.newIndex + 1, "old_index": e.oldIndex + 1}) })
        if (!response.ok) {
          throw new Error(`Can't reorder: HTTP ${response.statusCode}`)
        }
      }
    })
  }
}