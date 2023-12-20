<result>{
  for $state in distinct-values(/congress/people/person/role/@state)
  let $m_count := count(/congress/people/person[@gender = 'M']/role[@current = '1' and @state = $state])
  let $f_count := count(/congress/people/person[@gender = 'F']/role[@current = '1' and @state = $state])

  stable order by
    $state

  return element {$state} {      (: with {}, tag name is computed :)
    <M>{attribute count {$m_count}}</M>, <F>{attribute count {$f_count}}</F>
  }
}</result>
