import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "ticker" ]

  tickerTargetConnected(_element) {
    this.dispatch('toggle', { detail: { show: true } })

    const starts = this.tickerTarget.dataset.starts
    const ends = this.tickerTarget.dataset.ends

    this.seconds = ends - starts

    if(this.seconds < 1) { return }

    this.tickerInterval = setInterval(() => {
      this.seconds--;
      
      this.tickerTarget.innerText = this.seconds;

      if(this.seconds < 1) {
        clearInterval(this.tickerInterval)
      }
    }, 1000);
  }

  tickerTargetDisconnected(_element) {
    this.dispatch('toggle', { detail: { show: false } });

    clearInterval(this.tickerInterval)
  }
}