# 登录表单
jQuery ->
  jQuery(document).on 'pjax:success', ->
    jQuery('.page-sign form').hide().fadeIn(500)

jQuery ->
  class AuthInfo
    constructor: ()->
      @$infobox = jQuery('.page-sign .sign-res-info')

    clear: ->
      @$infobox.removeClass('success').find('.info:visible').remove()
      return @

    add: (info)->
      $info = @$infobox.find('.info').first().clone().show()
      $info.find('span').html(info)
      @$infobox.append($info)
      return @

    show: ->
      @$infobox.slideDown(200)
      return @

    success: ->
      @clear()
      @$infobox.addClass('success').find('.info.ok').show()
      @show()

      return @

  jQuery(document).on 'ajax:error', '.page-sign .sign-in-form', (evt, xhr)->
    info = xhr.responseText
    new AuthInfo().clear().add(info).show()

  jQuery(document).on 'ajax:success', '.page-sign .sign-in-form', (evt, xhr)->
    new AuthInfo().success()
    url = xhr.location
    if url!=null || url != '' || url != '/'
      window.location.href = url
    else
      window.location.href = '/'

  jQuery(document).on 'ajax:error', '.page-sign .sign-up-form', (evt, xhr)->
    infos = jQuery.parseJSON(xhr.responseText)
    ai = new AuthInfo().clear()
    jQuery.each infos, (index, info)->
      ai.add(info)
    ai.show()

  jQuery(document).on 'ajax:success', '.page-sign .sign-up-form', (evt, xhr)->
    new AuthInfo().success()
    url = xhr.location
    if url!=null || url != '' || url != '/'
      window.location.href = url
    else
      window.location.href = '/'


    

