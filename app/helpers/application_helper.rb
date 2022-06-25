# frozen_string_literal: true

module ApplicationHelper
  def prepend_flash
    turbo_stream.prepend 'flash', partial: 'shared/flash'
  end

  def nav_tab(title, url, options = {})
    current_page = options.delete :current_page

    css_class = current_page == title ? 'text-secondary' : 'text-white'

    options[:class] = if options[:class]
                        "#{options[:class]} #{css_class}"
                      else
                        css_class
                      end

    link_to title, url, options
  end

  def currently_at(current_page = '')
    render partial: 'shared/menu', locals: { current_page: }
  end

  def full_title(page_title = '')
    base_title = 'MCS Answer'
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end

  def gravatar_for(user:, size: 30, css_class: '')
    image_tag "https://www.gravatar.com/avatar/#{user.gravatar_hash}.jpg?s=#{size}",
              class: "rounded #{css_class}", alt: user.name
  end
end
