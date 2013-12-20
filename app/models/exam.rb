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

  def image_size_validation
    sz = File.size?(self.image_path)
    fsize_cond = !sz.blank? && sz > 0
    #if fsize_cond
      #puts " *** It exists ***"
    #end
    return fsize_cond
  end

  def check_file
    return File.exist? image_path 
  end

  def check_right_dir
    return self.image_dir.include?(self.id.to_s)
  end

  
  def destroy
   super
    begin
      FileUtils.rm self.image_path
      FileUtils.rm_rf self.image_dir
    rescue Exception => exc
      puts "Oooops, encountered an exception #{exc}"
    end
  end


  def read_files_img
    return File.readable? self.image_path
  end

  def split_file
    a = File.split self.image_dir
    #exam_id = a[-1]
    exam_id = File.pop
    exam_id.blank? self.image_dir
  end




end
