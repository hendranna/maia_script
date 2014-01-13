class Exam < ActiveRecord::Base
  
  attr_accessible :patient_id, :image

  belongs_to :patient

  EXAM_BASE_DIR="#{Rails.root.to_s}/examResults"

  def image_dir
    EXAM_BASE_DIR + "/#{self.patient_id}/#{self.id}"
  end

  def image_path
    return EXAM_BASE_DIR + "/#{self.patient_id}/#{self.id}/#{self.image}"
  end

  def check_right_dir
    return self.image_dir.include?(self.id.to_s)
  end

  def check_file
    return File.exist? image_path rescue patient_id = nil
  end

  def image_size_validation
    sz = File.size?(self.image_path)
    fsize_cond = !sz.blank? && sz > 0 && image != nil
    return fsize_cond
  end
  
  #def destroy
   #super
    #begin
      #FileUtils.rm self.image_path
      #FileUtils.rm_rf self.image_dir
    #rescue Exception => exc
      #puts "Oooops, encountered an exception #{exc}"
    #end
  #end

  def self.check_consistence_from_image(image_path)
    ex_id = image_path.split("/").pop(2).first.to_i rescue 0
    ex_obj = Exam.find(ex_id) rescue nil
    return ex_obj.blank? ? false : true
  end

  def self.check_consistence_from_patient(image_path)
    pat_id = image_path.split("/").pop(3).first.to_i rescue 0
    pat_obj = Patient.find(pat_id) rescue nil
    return pat_obj.blank? ? false : true
  end

  def self.report_full_consistency

    Dir.entries(EXAM_BASE_DIR+"/").each do |entry|
      next if [".",".."].include?(entry)

      Dir.entries(EXAM_BASE_DIR+"/"+entry+"/").each do |subentry|
        next if [".",".."].include?(subentry)

        image_file_name = EXAM_BASE_DIR+"/"+entry+"/"+subentry+"/image.jpg"
          
        dir_generic = false 
        pat_generic = false
        if File.exist? image_file_name
          dir_generic = Exam.check_consistence_from_image(image_file_name)
          pat_generic = Exam.check_consistence_from_patient(image_file_name)
        end

        if dir_generic
          return "This exam id: #{subentry} exists"
        else
          return "Oops, this is a nasty exam!"
        end

        if pat_generic 
          return "This patient id: #{entry} exists"
        else
          return "Naughty patient, you are not in the database!"
        end

      end
    end
  end

end
