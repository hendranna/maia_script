
puts "Preparing for testing: erasing patients and exams"

Patient.all.each {|p| p.destroy}
Exam.all.each {|e| e.destroy}

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
            n = rand(1...5)
            if n != 1
              e = Exam.create patient_id: p.id, image: 'image.jpg'
              FileUtils.mkdir_p e.image_dir unless File.directory? e.image_dir
              FileUtils.cp EXAM_FAKE_IMAGE, e.image_path
            end
          end
      end
end



















  





  
    










