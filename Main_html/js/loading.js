$(function() {
  var loader_h = $('#loader').height();
  $('#loader-bg ,#loader').css('display','block');
  $('#loader').css({
    'height' : loader_h + 'px',
    'margin-top' : '-' + loader_h + 'px'
  });
});

$(function(){
  setTimeout('stopload()',10000);
});

$(window).on("load", function () { 
  setTimeout('stopload()');
});


function stopload(){
  $('#loader-bg').delay(900).fadeOut(800);
  $('#loader').delay(600).fadeOut(300);
}
