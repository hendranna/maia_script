puts "Reading the images..."
 
    #Exam.report_full_consistency

global_report_full_consistency_test = true
  global_report_full_consistency_test = Exam.report_full_consistency

unless global_report_full_consistency_test
  puts "...failed!"
else
  puts "...wow, all passed!" 
end


