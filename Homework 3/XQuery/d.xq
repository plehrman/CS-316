<result>{
  for $p in /congress/people/person,
    $r in $p/role[@state = 'NC' and @type = 'rep' and @current = '1']
  stable order by
    number($r/@district)
  return 
    <representative name = '{$p/@name}' district = '{number($r/@district)}' party = '{$r/@party}'>
    </representative>
}</result>