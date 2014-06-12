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

  def humanized_hash(hash)
    array = Array.new
    hash.each do |key, value|
      array << "#{key.to_s.camelize}:#{value.to_s.camelize}"
    end
    if hash.empty?
      return 'None'
    else
      return array.join(' | ')
    end
  end

end
