class Board < ActiveRecord::Base

	def self.send_email
			UserMailer.report.deliver
	end

	def self.remove
		begin
			FileUtils.rm_rf(Dir.glob("#{Rails.root}/log/*"))
		rescue
		end
	end

end
