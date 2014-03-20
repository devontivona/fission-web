$ ->
  # Make rows of tables selectable
  $("tr[data-target]").click(->
    Turbolinks.visit $(this).attr("data-target")
  ).find("a").hover (->
    $(this).parents("tr").unbind "click"
  ), ->
    $(this).parents("tr").click ->
      Turbolinks.visit $(this).attr("data-target")