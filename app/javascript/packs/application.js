require("jquery")
import "bootstrap"
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "@fortawesome/fontawesome-free/css/all"

$(function(){
  $('.dropright').hover(function() {
      $(this).addClass('open');
  },
  function() {
      $(this).removeClass('open');
  });
});

Rails.start()
Turbolinks.start()
ActiveStorage.start()
