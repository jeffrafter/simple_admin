Factory.sequence :name_sequence do |n|
  "name #{n}"
end

Factory.define :place do |f|
  f.name { Factory.next :name_sequence }
end

Factory.define :thing do |f|
  f.name { Factory.next :name_sequence }
  f.happy true
  f.age 10
  f.association :place
end
