$(document).ready(function() {
 $('th.tablegrid_th.clickable').click(function(){window.location = $(this).closest('tr').attr('rel');})
 $('td.tablegrid_td.clickable').click(function(){window.location = $(this).closest('tr').attr('rel');})
});