# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Timer

  #TODO: КУКИ при загрузке страницы
  $(window).bind('onload', ->
    if localStorage.getItem('current_started_timer')
      send_data(false, false)
  )

  start_button = document.getElementById('button_start')
  time_view = document.getElementById('time_view')
  time_view.innerHTML = "00:00:00"
  document.getElementById('button_nonpressed').src = 'assets/button1.png'

  is_start_clicked = false

  set_date = (start_date)->
    @hours = start_date.getHours()
    @minutes = start_date.getMinutes()
    @seconds = start_date.getSeconds()
    @showed_timer = setInterval(set_time_view, 500)


 #TODO: если наступает следующий день то время разбивается на два дня: закончившийся и наступивший.
  set_time_view = ->
    @date = new Date()
    @date.setHours(@date.getHours() - @hours)
    @date.setMinutes(@date.getMinutes() - @minutes)
    @date.setSeconds(@date.getSeconds() - @seconds)

    h = @date.getHours()
    m = @date.getMinutes()
    s = @date.getSeconds()

    h = '0' + h if h < 10
    m = '0' + m if m < 10
    s = '0' + s if s < 10

    time_view.innerHTML = h + ":" + m + ":" + s

  start_button.onclick= ->
    send_data(true, is_start_clicked)

  send_data = (key ,is_clicked)->
    switch is_clicked
      when false
        if key
          if localStorage.getItem('is_timer_started1') == '11'
            alert('Таймер запущен на другой странице')
          else
            if localStorage.getItem('current_started_timer')
              start_date = new Date(localStorage.getItem('current_started_timer'))
            else
              start_date = new Date

            set_date(start_date)
            is_start_clicked = true
            document.getElementById('button_nonpressed').src = 'assets/button12.png'

            if typeof(Storage) != undefined
              localStorage.setItem('is_timer_started1', 11)
              document.cookie = 'start_date=' + start_date

      when true
        $.ajax(
          type: "POST",
          url: "ajax",
          data: "time=" + @date,
          success:
            clearInterval(@showed_timer)
        )

        is_start_clicked = false

        if typeof(Storage) != undefined
          localStorage.setItem('is_timer_started1', 22)
          document.cookie = "start_date=; expires=Thu, 01 Jan 1970 00:00:00 UTC"

        document.getElementById('button_nonpressed').src = 'assets/button1.png'

  #TODO: настроить нормально закрытие окна при запущенно таймере
