(nonweight, grams, pricekg,pricelb)=>
let
p = if nonweight <> null then nonweight
else if grams <> null then grams else if pricelb <> null then pricelb else pricekg,
l = if p <> null then Text.Trim(Text.Combine(List.Sort(List.Distinct(List.RemoveNulls(List.Select(List.Transform(Text.Split(p,","),Text.Trim),each _ <> "")))),",")) else null
in if l = null or l  = "" then null
else if Text.Contains(l,",") then l 
else if Text.Contains(l,"/") and Text.Contains(l,".00") then Text.Replace(l,".00","") 
else if Text.Contains(l,"$0.") then Text.Replace(Text.Replace(l,"$",""),"0.","")&"¢" 
else if Text.Contains(l,".00") & Text.Contains(l,",") = false then "$"&Text.Replace(l,".00","")
else Text.Replace(l,"$","")
