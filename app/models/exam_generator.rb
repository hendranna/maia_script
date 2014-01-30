class ExamGenerator < ActiveRecord::Base

def self.generate(n_patients,exams_per_patient)
  i=0
  while (i<n_patients) do
    p=self.generate_patient("1970-01-01","male","bulk_lastname_#{i}","bulk_firstname_#{i}")
    j=1
    while (j<exams_per_patient+1) do
      eye = j%2==1 ? "left" : "right"
      ex=generate_exam(p,eye,p.race_id)
      j+=1
    end
  i+=1
  end
end

def self.generate_patient(birthdate,gender,lastname,firstname)
  p=Patient.create(:firstname => firstname, :lastname => lastname.capitalize, :birthdate => birthdate, :gender => gender, :race_id => 1, :created_at => Time.now)
  p.history
#  p.generate_uuid
  p.save
  return p
end

def self.generate_exam(p,eye,race_id)
  field=0
  num_fields=1
  parent_id=-1
  e = DrsExam.create(:patient_id => p.id, :eye => eye, :field => field, :num_fields => num_fields,  :race_id => race_id, :parent_id => -1, :error_code => nil, :created_at => Time.now, :completed => 1)
#  e.generate_uuid
  e.destination_dir
  e.save
  puts e.id.to_s
  FileUtils.cp "/opt/drs/web/misc/template_exams/"+eye+"/1_"+eye+"_0_001_rgb.jpg", $basedir+"/public/"+e.image_jpg(false)
  FileUtils.cp "/opt/drs/web/misc/template_exams/"+eye+"/1_examInfo.xml", e.examinfo

  old_exam_id="EXAM_ID"
  new_exam_id=e.id

  FileUtils.mv e.examinfo, e.examinfo+"ORI"
  string="cat #{e.examinfo}ORI | sed \"s/<ExamID>EXAM_ID</<ExamID>#{new_exam_id}</g\" > #{e.examinfo}"
  System.command(string)

  return e

end 

end
