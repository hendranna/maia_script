class Patient < ActiveRecord::Base
	
  attr_accessible :firstname, :lastname

  has_many :exams

  def patient_dir
		"#{Exam::EXAM_BASE_DIR}/#{self.id}"
	end


  def destroy
  	super
  	begin
  		FileUtils.rm_rf self.patient_dir
  	rescue Exception => exc
  		puts "Oooops, encountered an exception #{exc}"
  	end
  end

end
 



