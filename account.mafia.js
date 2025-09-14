/*
uses account.php's jquery 1.3, from 2009 the first year Barack Obama was president. if jquery1.3 was a person, she would be eligable for a driving permit. 
we inherit the page's events (that submit to account.php) for buttons, so make fake ones out of spans. 
we also inherit the event for checkboxes but we ignore these (can't put an id on divs). 
*/
//var url_form='account.mafia.ash';
//var url_form='test_form.ash';

$('#ADD').bind('click', function(e) {
chk = $('#addcheck').attr('checked') ? 1 : 0;
$.ajax({
    url: url_form,//'test_form.ash',
    type: 'POST',
    data: { action: 'NEW', value: $('#addvalue').val(), bool:chk },
    success: function(response) {
        setTimeout(function() {
            $('#guts').load(url_form);
        }, 200);
    }
});
  return false;
});

function showSave(div) {
  var $div = $(div);
  $div.removeClass('disabled');
  var $saving = $div.find('.sav');
  $saving.css('color','blue').text('Saved');
  setTimeout(function () { $saving.text(''); }, 1000);
}

$('.update').bind('click', function(e) {
  e.preventDefault();
  var $btn = $(this);
  var $item = $btn.closest('.item');
  var key = $item.attr('data-value');

  // build payload: prefer text input, else checkbox
  var $text = $item.find('.update-input');
  var $chk  = $item.find('.update-checkbox');
  var updateVal = '';
  if ($text.length) {
    updateVal = $text.val();
  } else if ($chk.length) {
    updateVal = $chk.is(':checked') ? "true" : "false";
  }

  $.ajax({
    url: url_form,
    type: 'POST',
    data: { action: 'update', value: key, update: updateVal },
    success: function(response) {
      showSave($item);
    }
  });

  return false;
});


$('.destroy').bind('click', function() {
  var $span = $(this);
  var value = $span.data('value') || $span.attr('data-value');

  $.ajax({
    url: url_form,
    type: 'POST',
    data: { action: 'destory', value: value },
    success: function() {
      $span.closest('.item').remove();
    },
    timeout:1000
  });

  return false;
});

/*
$('#sendRequest').bind('click', function() {
  var userInput = $('#userInput').val();
  $.ajax({
    url: url_form,
    type: 'POST',
    data: { action: 'shitthebed', userInput: userInput },
    success: function(response) {
      $('#DN_response').text(response);
    },
    error: function(xhr, status, error) {
      $('#DN_response').text('Error: ' + xhr.status + ' ' + error);
    }
  });
});
*/
