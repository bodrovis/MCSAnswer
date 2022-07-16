import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = {
    game: String
  }
  static targets = [ 'item' ]

  connect() {
    const gameId = this.gameValue

    this.sortable = new Sortable(this.element, {
      handle: ".js-sort-handle",
      onEnd: async (e) => {
        try {
          this.disable()

          const response = await patch(
            `/admin/games/${gameId}/reorder_questions`,
            {
              body: JSON.stringify({"new_index": e.newIndex + 1, "old_index": e.oldIndex + 1})
            }
          )

          if (!response.ok) {
            throw new Error(`Can't reorder: HTTP ${response.statusCode}`)
          }

          this.updatePositions()
        } catch (e) {
          console.error(e)
        } finally {
          this.enable()
        }
      }
    })

    this.updatePositions()
  }

  disable() {
    this.sortable.option('disabled', true)
    this.sortable.el.parentNode.classList.add('opacity-50')
  }

  enable() {
    this.sortable.option('disabled', false)
    this.sortable.el.parentNode.classList.remove('opacity-50')
  }

  updatePositions() {
    this.itemTargets.forEach((item, index) => {
      item.querySelector('.js-position').innerText = index + 1
    })
  }
}