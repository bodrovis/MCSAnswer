import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = {
    game: String
  }

  connect() {
    const gameId = this.gameValue

    this.sortable = new Sortable(this.element, {
      onEnd: async function(e) {
        try {
          this.option('disabled', true)
          this.el.parentNode.classList.add('opacity-50')
          const response = await patch(`/admin/games/${gameId}/reorder_questions`, { body: JSON.stringify({"new_index": e.newIndex + 1, "old_index": e.oldIndex + 1}) })
          if (!response.ok) {
            throw new Error(`Can't reorder: HTTP ${response.statusCode}`)
          }
        } catch (e) {
          console.error(e)
        } finally {
          this.option('disabled', false)
          this.el.parentNode.classList.remove('opacity-50')
        }
      }
    })
  }

  disable() {
    this.sortable.option('disabled', true)
  }

  enable() {
    console.log('hi')
    this.sortable.option('disabled', false)
  }
}