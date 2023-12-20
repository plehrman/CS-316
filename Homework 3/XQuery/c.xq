<result>{
  for $p in /congress/people/person[@gender = 'F']
  let $r := $p/role[@current = 1]
  let $birthdate := xs:date($p/@birthday)
  let $a := 2023 - year-from-date($birthdate)
  where $r[@party = 'Democrat']
  order by
    number($a) descending,
    $p/@name
  return 
    <person name="{$p/@name}" age="{$a}" state="{$r/@state}" type="{$r/@type}">
    </person>
}</result>
