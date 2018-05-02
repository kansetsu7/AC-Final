// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require_tree .

$(document).on('turbolinks:load', function(){
  setEditClick();
});

function setEditClick() {
  $("div.btn[value='Edit']").on('click', function(){
    var self = this
    var commenmt_id = $(self).parent().parent().attr('id');
    var content = $(self).parent().parent().children('.col-11').text().trim();

    console.log(commenmt_id)

    $.ajax({
      url: '/comments/' + commenmt_id + '/edit',
      method: 'get',
      dataType: 'json',
      data: { 
        id: parseInt(commenmt_id),
        content: content
      },
      success: function(data){
        $('div.row#' + commenmt_id).html(data['commentEditHtml']);
      }
    }).done(function(){
      setCancelClick();
    });  
  }); // change comment to comment form when edit btn is clicked  
}

function setCancelClick() {
  $("div.btn[value='Cancel']").on('click', function(){
    console.log('zzzzzzzzz');
    var self = this
    var commenmt_id = $(self).attr('id');

    console.log('Cancel'+commenmt_id)

    $.ajax({
      url: '/comments/' + commenmt_id + '/cancel',
      method: 'get',
      dataType: 'json',
      data: { 
        id: parseInt(commenmt_id)
      },
      success: function(data){
        $('div.row#' + commenmt_id).html(data['commentCancelHtml']);
      }
    }).done(function(){
      setEditClick();
    });  
  });
}