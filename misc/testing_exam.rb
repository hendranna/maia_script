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
   # puts "checking #{self.id}"
    if self.patient 
      return self.image_dir.include?(self.patient_id.to_s)
    else
      puts "The exam #{self.id} doesn't have a patient!"
    end
  end

  def check_file
    if FileTest.exists? (EXAM_BASE_DIR + "/#{self.patient_id}/#{self.id}/#{self.image}")
      return self.image
    else
      puts  "The image #{self.image} for the exam  #{self.id} doesn't exist!" 
    end
  end

  def image_size_validation
    sz = File.size?(self.image_path)
    if fsize_cond = !sz.blank? && sz > 0
      return fsize_cond
    else
      puts "The image #{self.image} for the exam #{self.id} has no validation!"
    end
  end

  def self.check_db_consistency

    global_checkdir_test = true
    Exam.all.each do |e|
      global_checkdir_test = e.check_right_dir
      #break unless global_checkdir_test
    end

    global_checkfile_test = true
    Exam.all.each do |e|
      global_checkfile_test = e.check_file
      #break unless global_checkfile_test
    end
    
    global_fsize_test = true
    Exam.all.each do |e|
      global_fsize_test = e.image_size_validation
      #break unless global_fsize_test
    end 
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

  def self.check_consistence_from_exam(image_path)
      pat_id = image_path.split("/").pop(3).first.to_i rescue 0 
      pat_obj = Patient.find(pat_id) rescue nil
      return pat_obj.blank? ? false : true
  end

  def self.report_full_consistency

    Dir.entries(EXAM_BASE_DIR+"/").each do |entry|
      next if [".",".."].include?(entry)
       
      Dir.entries(EXAM_BASE_DIR+"/"+entry+"/").each do |subentry|
        next if [".",".."].include?(subentry)

      image_file_name = EXAM_BASE_DIR+"/"+entry+"/"+subentry+"/"+"image.jpg"

      if File.directory? image_file_name
        Dir.entries(EXAM_BASE_DIR+"/"+entry+"/"+subentry+"/").each do |the_image|
          [".",".."].include?(the_image) 
        end
      end 
      
      #image_file_name = EXAM_BASE_DIR+"/"+entry+"/"+subentry+"/"+"image.jpg" 

      dir_generic = true && pat_generic = true
      if File.exist? image_file_name 
        dir_generic = Exam.check_consistence_from_image(image_file_name)
        pat_generic = Exam.check_consistence_from_exam(image_file_name) 
      end
      
      global_checkfile_test = true
        Exam.all.each do |e|
          global_checkfile_test = e.check_file
        end
        global_fsize_test = true
        Exam.all.each do |e|
          global_fsize_test = e.image_size_validation
        end 
        
         #Exam.all.each {|e| e.check_file && e.image_size_validation}
        case 
        when dir_generic == true && pat_generic == true && (global_checkfile_test = true && global_fsize_test = true) 
         puts "The image for the exam #{subentry} is valid, the exam is in our Database and has assigned the patient #{entry} that is in our Database too!"

        when dir_generic == true && pat_generic == true && (global_checkfile_test = false && global_fsize_test = false) 
          puts "The image for tha exam #{subentry} doesn't exist, the exam is in our Database, and the patient assigned #{entry} is in our Database too!"

        when dir_generic == true && pat_generic == false && (global_checkfile_test = true && global_fsize_test = true) 
          puts "The image for the exam #{subentry} exist, the exam is in our Database, but the patient assigned #{entry} is not in our Database"

        when dir_generic == true && pat_generic == false && (global_checkfile_test = false && global_fsize_test = false) 
          puts " The image for the exam #{subentry} does't exist, the exam is in our Database and the patient assigned #{entry} is not in our Database"

        when dir_generic == false && pat_generic == true && (global_checkfile_test = true && global_fsize_test = true) 
          puts "The image exists for the exam  #{subentry}, the exam is not in our Database, but the patient #{entry} is not in our Database"

        when dir_generic == false && pat_generic == false && (global_checkfile_test = true && global_fsize_test = true) 
          puts "The image exist, but the patient #{entry} and the exam #{subentry} doesn't exist!"

        when dir_generic == false && pat_generic == true && (global_checkfile_test = false && global_fsize_test = false) 
          puts "The image for the exam #{subentry} doesn't exist, the exam it's not in our Database and the patient assigned #{entry} is in our Database "

        
        else dir_generic == false && pat_generic == false && (global_checkfile_test = false && global_fsize_test = false) 
          puts "The image for the exam #{subentry} doesn't exist, the exam is not in our Database, and the patient assigned #{entry} is not in our Database" 
       
        end
        
      end
    end
  end
end
end
