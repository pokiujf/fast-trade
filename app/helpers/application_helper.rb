module ApplicationHelper
  
  def app_title
    if @title
      "#{ @title } - #{ I18n.t('links.fast_trade') }"
    else
      I18n.t('links.fast_trade')
    end
  end
  
  def fa_for_msg(msg_type)
    case msg_type
    when 'success' then raw("<i class='fa fa-check fa-lg'></i>")
    when 'info' then raw("<i class='fa fa-info fa-lg'></i>")
    when 'danger' then raw("<i class='fa fa-exclamation fa-lg'></i>")
    end
  end
  
end
