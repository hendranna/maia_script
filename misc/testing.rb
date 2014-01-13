puts "Checking ..."

  global_checkdir_test = true
  Exam.all.each do |e|
    global_checkdir_test = e.check_right_dir
    next if global_checkdir_test
      unless global_checkdir_test
        puts "...failed!"
      else
        puts "...wow, all passed!"
      end
      global_checkfile_test = true
        global_checkfile_test = e.check_file
        next if global_checkfile_test
          unless global_checkfile_test
            puts "...failed!"
          else
            puts "...wow,all passed!"
          end
          global_fsize_test = true
          
            global_fsize_test = e.image_size_validation
            break unless global_fsize_test
          
          unless global_fsize_test
            puts "...failed!"
          else
            puts "...wow, all passed!"
          end     
      
  end
  


