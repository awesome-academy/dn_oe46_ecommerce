require("jquery")
import "bootstrap"
//= require turbolinks
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "@fortawesome/fontawesome-free/css/all"
import "./jquery.flexslider"
import "./pignose.layerslider"

$(function(){
  $('.dropright').hover(function() {
      $(this).addClass('open');
  },
  function() {
      $(this).removeClass('open');
  });
});

Rails.start()
ActiveStorage.start()

$(function(){
  $('.dropright').hover(function() {
      $(this).addClass('open');
  },
  function() {
      $(this).removeClass('open');
  });
});

$(window).load(function() {
  $('.flexslider').flexslider({
  animation: "slide",
  controlNav: "thumbnails"
  });
});

jQuery(function($) {
  $("tr[data-link]").click(function() {
  window.location = this.dataset.link
  });
})
