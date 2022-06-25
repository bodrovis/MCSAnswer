import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "ticker" ]

  tickerTargetConnected(_element) {
    this.seconds = 60

    this.tickerInterval = setInterval(() => {
      this.seconds--;
      
      this.tickerTarget.innerText = this.seconds;

      if(this.seconds < 1) {
        clearInterval(this.tickerInterval)
      }
    }, 1000);
  }

  tickerTargetDisconnected(_element) {
    clearInterval(this.tickerInterval)
  }
}