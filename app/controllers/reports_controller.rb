class ReportsController < ApplicationController
	load_and_authorize_resource param_method: :my_sanitizer

	def index
		if params[:message]
			status = params[:message].split("_")[0]
			line_no = params[:message].split("_")[1]

			status == "on" ? status = false : status = true

			Line.find_by(:no=>line_no).update!(:status=>status)
		end

		if current_user.line.reports == []
			@target_and_opr = Report.new
			@target_and_opr.detailreports.build
		elsif current_user.line.reports.where("tanggal = ?",Date.today) == []
			@target_and_opr = Report.new
			@target_and_opr.detailreports.build
		else
			@target_and_opr = current_user.line.reports.where("tanggal = ?",Date.today).first
			@target_and_opr.detailreports.last
		end

	end

	def data
		if params[:search]
			begin
				@data = Line.where("no=?",params[:no].to_i).first.reports.where("tanggal = ?",params[:tanggal].to_date)
			rescue
				@data = []
			end
		end

		authorize! :data, current_user
	end

	def show

	end

	def new
		if params[:from_tablet]
			@status = Report.hourly_per_user(params[:user_id],params[:record])
		end
	end

	def create #first time when line baru dipake pada hari tsb
		if Time.now.strftime("%H").to_i != 12 
			params[:report][:tanggal] = Date.today
			params[:report][:detailreports_attributes]["0"][:jam] = Time.now.strftime("%H")


			@report = current_user.line.reports.new(my_sanitizer)
		    @status = @report.save
		end
	end

	def edit
	end

	def update
		jam = Time.now.strftime("%H").to_i
		detailreport_id = params[:report][:detailreports_attributes]["0"][:id].to_i

		defect_fly = 0

		if jam != 12 and Detailreport.find(detailreport_id).jam >= Time.now.strftime("%H").to_i
		 	@report = Report.find(params[:id])

			if params[:status] == "actual"
				
				params[:report][:detailreports_attributes]["0"][:act] = @report.detailreports.find(detailreport_id).act.to_i + 1

			elsif params[:status] == "int_defect"
				if params["11A"]
					params[:report][:detailreports_attributes]["0"][:defect_int] = @report.detailreports.find(detailreport_id).defect_int.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["11B"]
					params[:report][:detailreports_attributes]["0"][:defect_int_11b] = @report.detailreports.find(detailreport_id).defect_int_11b.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["11C"]
					params[:report][:detailreports_attributes]["0"][:defect_int_11c] = @report.detailreports.find(detailreport_id).defect_int_11c.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["11J"]
					params[:report][:detailreports_attributes]["0"][:defect_int_11j] = @report.detailreports.find(detailreport_id).defect_int_11j.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["11L"]
					params[:report][:detailreports_attributes]["0"][:defect_int_11l] = @report.detailreports.find(detailreport_id).defect_int_11l.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["13D"]
					params[:report][:detailreports_attributes]["0"][:defect_int_13d] = @report.detailreports.find(detailreport_id).defect_int_13d.to_i + 1
					defect_fly = defect_fly + 1
				end

			elsif params[:status] == "ext_defect"
				if params["BS2"]
					params[:report][:detailreports_attributes]["0"][:defect_ext] = @report.detailreports.find(detailreport_id).defect_ext.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["BS3"]
					params[:report][:detailreports_attributes]["0"][:defect_ext_bs3] = @report.detailreports.find(detailreport_id).defect_ext_bs3.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["BS7"]
					params[:report][:detailreports_attributes]["0"][:defect_ext_bs7] = @report.detailreports.find(detailreport_id).defect_ext_bs7.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["BS13"]
					params[:report][:detailreports_attributes]["0"][:defect_ext_bs13] = @report.detailreports.find(detailreport_id).defect_ext_bs13.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["BS15"]
					params[:report][:detailreports_attributes]["0"][:defect_ext_bs15] = @report.detailreports.find(detailreport_id).defect_ext_bs15.to_i + 1
					defect_fly = defect_fly + 1
				elsif params["BS17"]
					params[:report][:detailreports_attributes]["0"][:defect_ext_bs17] = @report.detailreports.find(detailreport_id).defect_ext_bs17.to_i + 1
					defect_fly = defect_fly + 1
				end

			end

		    if @report.update(my_sanitizer)
			
			else #jika ada error karena validasi

			end

		 end
	end


	def destroy

	end



private
	def my_sanitizer
		params.require(:report).permit!
	end
end