class Exam < ActiveRecord::Base
  
  attr_accessible :patient_id, :image

  belongs_to :patient

  EXAM_BASE_DIR="#{Rails.root.to_s}/examResults"

  def patient_dir
    EXAM_BASE_DIR + "/#{self.patient_id}"
  end

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

require 'find' 
  def reading_images
    Find.find("#{Rails.root.to_s}/examResults/#{self.patient_id}/#{self.id}/#{self.image}") do |f|  
      type = case  
        when 
          File.file?("self.image") then " exists"   
        else 
          " doesn't exist"  
        end  
      puts "#{type}: #{f}"  
    end 
  end

  def self.check_consistence_from_image(image_path)
    ex_id = image_path.split("/").pop(2).first.to_i rescue 0
    ex_obj = Exam.find(ex_id) rescue nil
    return ex_obj.blank? ? false : true
  end

  def self.check_consistence_from_patient(image_path)
    pat_id = image_path.split("/").pop(3).first.to_i rescue 0
    return pat_id 
  end

  def self.report_full_consistency

    Dir.entries(EXAM_BASE_DIR+"/").each do |entry|
      next if [".",".."].include?(entry)

      Dir.entries(EXAM_BASE_DIR+"/"+entry+"/").each do |subentry|
        next if [".",".."].include?(subentry)
        
        image_file_name = EXAM_BASE_DIR+"/"+entry+"/"+subentry+"/image.jpg"
          
        generic = false
        if File.exist? image_file_name
          generic = Exam.check_consistence_from_image(image_file_name)
        end
        if generic
          puts "Ok for exam id #{subentry}"
        else
          puts "Oops, this is nasty!"
        end


        
      end
    end
  end

  def checking_id
    dir = self.image_dir
    transf_dir = dir.split("/")
    check_exam_id = transf_dir.pop.to_i
    check_patient_id = transf_dir.pop.to_i
    puts "fantastic" if check_exam_id == self.id
    puts "amazing" if check_patient_id == self.patient_id
  end
end
