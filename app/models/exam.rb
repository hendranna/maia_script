class Exam < ActiveRecord::Base
  
  attr_accessible  :id, :patient_id, :image

  belongs_to :patient

  EXAM_BASE_DIR="#{Rails.root.to_s}/examResults"

  def image_dir
    EXAM_BASE_DIR + "/#{self.patient_id}/#{self.id}"
  end

  #def image
    #return "stillPicture.png"
  #end

  def image_path
    return EXAM_BASE_DIR + "/#{self.patient_id}/#{self.id}/#{self.image}"
  end

  def check_right_dir
    if self.patient 
      return self.image_dir.include?(self.patient_id.to_s)
    else
        puts "The exam #{self.id} is in our Database, but the patient #{self.patient} is not in our Database, SO the exam is not in the right directory!\n"
      #self.broken_db("right")
      #return false
    end
  end

  def check_file
    if FileTest.exists? (EXAM_BASE_DIR + "/#{self.patient_id}/#{self.id}/#{self.image}")
      return self.image
    else
      puts  "The image '#{self.image}' for the exam  #{self.id} doesn't exist!\n" 
      #self.broken_db("no")      
      #return false
    end
  end

  def image_size_validation
    sz = File.size?(self.image_path)
    if fsize_cond = !sz.blank? && sz > 0
      return fsize_cond
    else
      puts "The image '#{self.image}' for the exam #{self.id} has no validations!\n"
      #self.broken_db("zero")
      #return self.id
    end
  end

  #@@broken_exams = { :zero_size => [], :no_image => [], :right_dir =>[]}

  #def broken_db(reason)
    
    #if (reason == "zero")
      #@@broken_exams[:zero_size] << self
    #end
    #if (reason == "no")
      #@@broken_exams[:no_image] << self
    #end
    #if (reason == "right")
      #@@broken_exams[:right_dir] << self
    #end

  #end

  def self.progress(j,exam_all)
    progress = (j == 1 ) ? "Progress \n" : ""
    if (j % exam_all / 100) == 0
      progress << "===>>"
      print "\r"
      print progress + "#{(j*100/exam_all)}%\n"
      $stdout.flush
      sleep 0.001
    end
  end  

  def self.check_db_consistency
    global_check_db_consistency_test = true
    exam_all = Exam.all.count
    j = 1 

    Exam.all.each do |e|
      global_check_db_consistency_test= e.check_right_dir && (e.check_file || e.image_size_validation)
      #puts "Images with problems on size:"
      self.progress(j,exam_all)
      j += 1
      #break unless global_check_db_consistency_test
    end
    #puts "Images with problems on size: #{@@broken_exams[:zero_size].collect {|x| puts x}}"
    #puts "Images with problems on image: #{@@broken_exams[:no_image].inspect}"
    #puts "Problems with the right directory: #{@@broken_exams[:right_dir].inspect}"
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
    if FileTest.exists? (image_path)
      ex_id = image_path.split("/").pop(2).first.to_i rescue 0
      ex_obj = Exam.find(ex_id) rescue nil 
      return  ex_obj.blank? ? false : true 
    end
  end

  def self.check_consistence_from_exam(image_path)
    if FileTest.exists? (image_path)
      pat_id = image_path.split("/").pop(3).first.to_i rescue 0
      pat_obj = Patient.find(pat_id) rescue nil
      return pat_obj.blank? ? false : true 
    end
  end 

  def self.report_full_consistency

    exam_all = Exam.all.count
    j = 1
    
    Dir.entries(EXAM_BASE_DIR+"/").each do |entry|

      next if [".",".."].include?(entry) 
       
      Dir.entries(EXAM_BASE_DIR+"/"+entry+"/").each do |subentry| 
        
        next if [".",".."].include?(subentry)
        
        image_file_name = EXAM_BASE_DIR+"/"+entry+"/"+subentry+"/"+"image.jpg"
        
        if File.exists? image_file_name 

          dir_generic = Exam.check_consistence_from_image(image_file_name)
          pat_generic = Exam.check_consistence_from_exam(image_file_name)
          self.progress(j,exam_all)
          j += 1
  
          case
          when dir_generic == true && pat_generic == true 
            puts "The image 'image.jpg' for tha exam #{subentry} exists, the exam is in our Database, and the patient assigned #{entry} is in our Database too!"

          when dir_generic == true && pat_generic == false 
            puts "The image 'image.jpg' for the exam #{subentry} exist, the exam is in our Database, but the patient assigned #{entry} is not in our Database"

          when dir_generic == false && pat_generic == true 
            puts "The image 'image.jpg' exists for the exam  #{subentry}, the exam is not in our Database, but the patient assigned #{entry} is in our Database"

          else dir_generic == false && pat_generic == false 
            puts "The image 'image.jpg' exist, but the patient #{entry} and the exam #{subentry} doesn't exist!"
          end
        end
      end
    end
  end
end
