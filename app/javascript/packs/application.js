require("jquery")
import "bootstrap"
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "@fortawesome/fontawesome-free/css/all"
import "./easyResponsiveTabs"
import "./jquery.flexslider"
import "./pignose.layerslider"
//= require jquery.easing

Rails.start()
Turbolinks.start()
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
