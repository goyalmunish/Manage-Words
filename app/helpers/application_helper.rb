module ApplicationHelper
  def get_flag_hash
    Flag.flag_hash
  end

  def get_flag(name, value)
    name = name.to_s
    value = value.to_i
    Flag.where(:name => name, :value => value).first
  end

  def page_title
    base_title = SITE_NAME || 'SiteNameIsNotSet'
    page_title_array = Array.new
    page_title_array << base_title
    page_title_array += @page_title if @page_title
    page_title_array.join(' | ')
  end
end

