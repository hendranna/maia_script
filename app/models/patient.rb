class Patient < ActiveRecord::Base
	
  attr_accessible :firstname, :lastname

  has_many :exams

  def patient_dir
		"#{Exam::EXAM_BASE_DIR}/#{self.id}"
	end

   def self.check_consistence_from_patient(patient_dir)
    pat_id = patient_dir.split("/").pop.first.to_i rescue 0
    pat_obj = Patient.find(pat_id) rescue nil
    return pat_obj.blank? ?  false : true
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
 



