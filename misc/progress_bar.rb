progress = 'Progress ['
1000.times do |i|
 
# i is number from 0-999
j = i + 1
 
  # add 1 percent every 10 times
  if j % 10 == 0
    progress << "="
    # move the cursor to the beginning of the line with \r
    print "\r"
    # puts add \n to the end of string, use print instead
    print progress + " #{j / 10} %"
 
    # force the output to appear immediately when using print
    # by default when \n is printed to the standard output, the buffer is flushed. 
    $stdout.flush
    sleep 0.05
  end
end
puts "\nDone!"




  e_all = Exam.all.count
    progress = "Progress ["
    (e_all).times do |i|
      j = i + 1
      if j % (e_all) == 0
        progress << "="
        print "\r"
        print progress + "]" + "#{j/e_all}%"
        $stdout.flush
        sleep 0.05