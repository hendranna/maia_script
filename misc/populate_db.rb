
puts "Preparing for testing: erasing patients and exams"

Patient.all.each {|p| p.destroy}
#Exam.all.each {|e| e.destroy}

puts "Populating..."

EXAM_FAKE_IMAGE = "#{Rails.root.to_s}/misc/exam_fake_image.jpg"

pat_names = [{fname: "Anna", lname: "Hendre"},
						{fname: "Mario", lname: "Rossi"},
            {fname: "Andrea", lname: "Tognolo"},
            {fname: "Giorgio", lname: "Burlini"},
            {fname: "Andrea", lname: "Amici"},
          	{fname: "Stefano", lname: "Spedicati"},
            {fname: "Matteo", lname: "Marcolin"}]

pat_names.each do |pat|
  
  p = Patient.create firstname: pat[:fname], lastname: pat[:lname] 
      if p.firstname != "Matteo" && p.lastname != "Marcolin"
          rand(1...5).times do
            e = Exam.create patient_id: p.id, image: 'image.jpg' 
            FileUtils.mkdir_p e.image_dir unless File.directory? e.image_dir
            FileUtils.cp EXAM_FAKE_IMAGE, e.image_path
          end
      end
end

puts "Checking image sizebyte ..."

  global_fsize_test = true
  Exam.all.each do |e|
    global_fsize_test = e.image_size_validation
    break unless global_fsize_test
  end
  unless global_fsize_test
    puts "...failed!"
  else
    puts "...wow, all passed!"
  end

puts "Cheking file ..."
  
  global_checkfile_test = true
  Exam.all.each do |e|
    global_checkfile_test = e.check_file
    break unless global_checkfile_test
  end
  unless global_checkfile_test
    puts "...failed!"
  else
    puts "...wow,all passed!"
  end

puts "Checking right directory ..."

  global_checkdir_test = true
  Exam.all.each do |e|
    global_checkdir_test = e.check_right_dir
    break unless global_checkdir_test
  end
  unless global_checkdir_test
    puts "...failed!"
  else
    puts "...wow, all passed!"
  end

puts "Reading the images..."
  Exam.all.each do |e|
    e.report_full_consistency
  end
 
#puts "checking ids... "
  
  #Exam.all.each do |e|
    #e.checking_id
  #end



















  





  
    










