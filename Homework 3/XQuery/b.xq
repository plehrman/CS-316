<result>{
let $m := /congress/committees/committee[@displayname = 'House Committee on Natural Resources']/subcommittee[@displayname = 'Energy and Mineral Resources']/member[@role = 'Ranking Member']/@id
let $p := /congress/people/person[@id = $m]
return 
    $p
}</result>