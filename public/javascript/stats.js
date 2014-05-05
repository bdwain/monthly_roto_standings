$(document).ready(function(){
  $(".statstable").tablesorter({
    headers: { 1: { sorter: false}},
    widgets: ['numbering', 'zebra']
  });
});