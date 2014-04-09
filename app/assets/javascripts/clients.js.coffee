$ ->
  # Make rows of tables selectable
  $("tr[data-target]").click(->
    Turbolinks.visit $(this).attr("data-target")
  ).find("a").hover (->
    $(this).parents("tr").unbind "click"
  ), ->
    $(this).parents("tr").click ->
      Turbolinks.visit $(this).attr("data-target")
  
  $('td[data-target]').click ->
    window.location = $(this).attr('data-target')