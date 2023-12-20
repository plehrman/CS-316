(:<result>{
  for $person in /congress/people/person,
    $role in /congress/people/person/role[@current = '1'],
    $previous_role in /congress/people/person/role[@current = '0']

  where $role = 'sen' and $previous_role = 'rep'

  stable order by
    $person/@name
  return 
    <member>$person/@name</member>
}</result>:)

<result>{
  for $person in /congress/people/person
  let $role := $person/role[@current = '1']
  let $previous_role := $person/role[not(@current)]

  where $role/@type = 'sen' and $previous_role/@type = 'rep'

  stable order by 
    $person/@name

  return 
    <member>{string($person/@name)}</member>
}</result>


