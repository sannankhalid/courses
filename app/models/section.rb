class Section < ActiveRecord::Base
  attr_accessible :name, :status,:personality_types
  has_many :courses
  serialize :personality_types,Array

  # def self.to_csv(options = {})
  #   CSV.generate(options) do |csv|
  #     csv << column_names
  #     all.each do |section|
  #       csv << section.attributes.values_at(*column_names)
  #     end
  #   end
  # end
  
  def personality_types
    read_attribute(:personality_types) || []
  end

  def personality_types=(perms)
    perms = perms.collect {|p| p unless p.blank? }.compact.uniq if perms.present?
    write_attribute(:personality_types, perms)
  end
end
