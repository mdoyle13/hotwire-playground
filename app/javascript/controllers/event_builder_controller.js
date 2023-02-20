import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-builder"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    document.addEventListener("turbo:before-frame-render", async (event) => {
      event.preventDefault();
      
      if (this.hasFormTarget) {
        let el = this.formTarget

        el.classList.add('animate__animated')
        el.classList.add('animate__fadeOutUp')
        el.addEventListener('animationend', () => {
          event.detail.resume()
        })
      } else {
        event.detail.resume()
      }
    })
  }
}
