import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'rateStar', 'rateBtn', 'frame', 'checkedBtn' ]

  findChecked() {
    if (this.hasCheckedBtnTarget) {
      let label = 0
      while (label < this.checkedBtnTarget.value) {
        let element = this.rateStarTargets[label];
        element.classList.remove("movie-text", "bi-star");
        element.classList.add("star-color", "bi-star-fill");
        label++
      }
    }
  }

  chooseRate({params}) {
    this.rateStarTargets.forEach(element => {
      if (element.dataset.number <= params.number) {
        element.classList.remove("movie-text", "bi-star");
        element.classList.add("star-color", "bi-star-fill");
      } else {
        element.classList.remove("star-color", "bi-star-fill");
        element.classList.add("movie-text", "bi-star");
      }
    });
    this.rateBtnTarget.classList.remove('disabled')
  }

  close() {
    const frame = this.frameTarget;
    frame.innerHTML = "";
    frame.removeAttribute("src");
  }
}
