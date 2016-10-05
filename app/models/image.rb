class Image < ActiveRecord::Base

 	has_attached_file :banner, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "no_image.png"
  	validates_attachment :banner, :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"]}, :size => { :less_than => 4000.kilobytes }


end
