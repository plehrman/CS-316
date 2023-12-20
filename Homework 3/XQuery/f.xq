<result>{
  for $person in /congress/people/person
  let $id := $person/@id
  
  where $person/role[@current = '1' and @state = 'NY']
  and not(exists(congress/committees/committee/member[@id = $id]))

  stable order by
    $person/@name

  return 
    <member>{string($person/@name)}</member>
}</result>
(:<result>{
  for $person in /congress/people/person
  let $person_id := $person/@id
  let $com_id := distinct-values(/congress/committees/committee/member/@id)

  where $person/role[@current = '1' and @state = 'NY']

  return 
    <member>{string($person/@name)}</member>
}</result> :)
