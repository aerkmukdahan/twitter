module ApplicationHelper

  def page_margin
    3
  end

  def start_page( items )
    items.current_page - page_margin > 1 ?
      items.current_page + page_margin - 1 < items.total_pages ?
        items.current_page - page_margin + 1
        : items.total_pages - page_margin * 2 + 1
      : 1
  end

  def end_page( items )
    items.current_page + page_margin < items.total_pages ?
    page_margin * 2 + start_page(items) - 
        ( items.current_page - page_margin > 1 ? 2 : 1 )
      : items.total_pages
  end

  def bg_class
    @dark_theme ? 'bg-dark' : ''
  end
  def bg_gray_class
    @dark_theme ? 'bg-secondary' : ''
  end
  def bg_parent_class
    @dark_theme ? 'bg-dark' : 'bg-white'
  end
  def bg_body_class
    @dark_theme ? 'bg-secondary' : 'bg-light'
  end
  def bg_nav_bar_class
    @dark_theme ? 'bg-dark' : 'bg-primary'
  end

  def text_class
    @dark_theme ? 'text-light' : ''
  end
  def text_gray_class
    @dark_theme ? 'text-light' : 'text-muted'
  end

  def border_class
    @dark_theme ? 'border-secondary' : ''
  end
  def border_bg_class
    @dark_theme ? 'border-secondary' : 'border-light'
  end
  def border_parent_class
    @dark_theme ? '' : 'border'
  end

  def btn_class
    @dark_theme ? 'btn-secondary' : 'btn-primary'
  end

end
