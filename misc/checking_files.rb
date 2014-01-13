
puts "Checking right directory..."
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
