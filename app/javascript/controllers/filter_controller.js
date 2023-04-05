import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'checkBox', 'link' ]

  changeUrl() {
    let params = []
    this.checkBoxTargets.forEach(element => {
      if (element.checked) { params.push(element.value) }
    });
    this.addParamsToUrl(params);
  }

  addParamsToUrl(params) {
    let stringParams = params.join('-')
    this.linkTarget.href = "/movies/categories/" + stringParams;
  }
}
