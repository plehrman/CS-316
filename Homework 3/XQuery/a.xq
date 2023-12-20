<result>{
for $l in /congress/people/person
where ends-with($l/@name, " Smith")
return 
    $l
}</result>