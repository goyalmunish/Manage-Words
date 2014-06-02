module ApplicationHelper
  def get_flag_hash
    Flag.flag_hash
  end

  def get_flag(name, value)
    name = name.to_s
    value = value.to_i
    Flag.where(:name => name, :value => value).first
  end

end

