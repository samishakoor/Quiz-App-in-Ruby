require 'csv'
file_name="problems.csv"
$set_timer=30

system("clear")
puts "Customize Timer? (0/1)"
choice=gets.chomp.to_i
puts
if(choice===1)
  puts "Enter Time for Timer(in seconds): "
  updated_timer=gets.chomp.to_i
  if updated_timer >= 0
    $set_timer=updated_timer
  else
    puts "Please Enter Valid Time for Timer(in seconds): "
    new_updated_timer=gets.chomp.to_i
    $set_timer=new_updated_timer
  end
end

puts
puts "Timer: #{$set_timer} seconds "
puts "Press Enter start the Timer ... "
input=gets



quiz = Thread.new do

  table = CSV.parse(File.read(file_name), headers: true)
  $no_of_questions=CSV.foreach(file_name, headers: true).count

  problems_arr=table.by_col[0]
  solutions_arr=table.by_col[1]
  $track = Array.new($no_of_questions,0)

  system("clear")

  $q_count = 0
  $right_answers=0
  $attempted=0

  while $q_count < $no_of_questions  do
  puts "                                     *** Question no.#{$q_count+1} ***"

    flag=1
    puts "What is the answer of #{problems_arr[$q_count]} ?"
    guessed_answer=gets.chomp

    $attempted+=1

    if guessed_answer==="0"
      flag=0
    end

    guessed_answer=guessed_answer.to_i

    if(guessed_answer==0 && flag==1)
      puts "Please Enter a valid answer (answer should be an integer value)!"
      new_guessed_answer=gets.chomp.to_i
      if new_guessed_answer===solutions_arr[$q_count].to_i
        $track[$q_count]=1
        $right_answers+=1
      end
    else
      if guessed_answer===solutions_arr[$q_count].to_i
        $track[$q_count]=1
        $right_answers+=1
      end
    end


    puts
    $q_count +=1
  end

  Thread.current[:value] = "Quiz Completed Before Time Ends !!!"

end

timer = Thread.new { sleep $set_timer; quiz.kill; puts }


=begin
$curr_time=0
timer = Thread.new do
while ($curr_time<$set_timer) do
sleep 1
$curr_time+=1
print ("\t\t\t\t\t Timer: #{$curr_time}\r")
end
 quiz.kill
end
=end

quiz.join
system("clear")
if quiz[:value]
  puts "#{quiz[:value]}"
else
  puts "TIME OVER !!!"
end

puts

puts "                                            *** Results ***"
puts
puts "Total Questions: #{$no_of_questions}"
puts "Attempted Questions: #{$attempted}"
puts "Correct Answers: #{$right_answers}"
#puts "Incorrect Answers: #{$attempted-$right_answers}"

puts
puts

puts "Incorrect(invalid or non-attempted) Questions :"
puts
$c=0
while  $c < $no_of_questions  do
  if $track[$c]==0
      puts "Question no. #{$c+1}"
  end
  $c+=1
end


