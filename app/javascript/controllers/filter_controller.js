import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'checkBox', 'link' ]
  static outlets = [ 'pagy' ]

  pagyOutletConnected(pagy, element) {
    if (this.hasPagyOutlet) {
      this.changePrevPaginationUrl()
      this.changeNextPaginationUrl()
    }
  }

  changeUrl() {
    let params = []
    this.checkBoxTargets.forEach(element => {
      if (element.checked) { params.push(element.value) }
    });
    this.addParamsToUrl(params);
  }

  addParamsToUrl(params) {
    let stringParams = params.join('-')
    this.linkTarget.href = `/movies/categories/${stringParams}/page`;
  }

  changePrevPaginationUrl() {
    let link = this.pagyOutlet.pagyPrevLinkTarget
    if (link.dataset.page === undefined) {
      link.classList.add("disabled")
      link.href = this.linkTarget.href + '/1';
    } else {
      link.classList.remove("disabled");
      link.href = `${this.linkTarget.href}/${link.dataset.page}`;
    };
  }

  changeNextPaginationUrl() {
    let link = this.pagyOutlet.pagyNextLinkTarget;
    if (link.dataset.page === undefined) {
      link.classList.add("disabled");
      link.href = this.linkTarget.href;
    } else {
      link.classList.remove("disabled");
      link.href = `${this.linkTarget.href}/${link.dataset.page}`;
    };
  }
}
