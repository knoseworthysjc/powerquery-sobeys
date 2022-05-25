(ot,p_nonweight,p_100g,p_lb,p_kg,r,oc) => 
let 
p= if p_nonweight <> null then p_nonweight
else if p_100g <> null then p_100g else if p_lb <> null then p_lb else p_kg,
l = if p <> null then Text.Trim(Text.Combine(List.Sort(List.Distinct(List.RemoveNulls(List.Select(List.Transform(Text.Split(p,","),Text.Trim),each _ <> "")))),",")) else null,
r = Text.Lower(r),
l_oc=Text.Lower(oc),
in_p = try if Text.Contains(r,"buy") and Text.Contains(r,"get") then "bogo"
else if Text.Contains(p,"/") and Text.Contains(r,"pay")=false then "Multi_Buy"
else if Text.Contains(r,"pay") then "bmsm"
else if Text.Contains(r,"%") or Text.Contains(l_oc,"% off") then "Save %%"
else if Text.Contains(r,"off") and Text.Contains(p, "0.") then "cent_off"
else if Text.Contains(r,"off") and Text.Contains(p, "0.") = false then "dollar_off"
else if Text.Contains(oc,"Starting At") then "Starting At"
else if Text.Contains(l,"/ea") then "price" 
else if p_100g <> null and p_100g <> "" then "price/100g"
else Text.Replace(Text.Lower(ot),"price/kg","pricelb") otherwise Text.Replace(Text.Lower(ot),"price/kg","pricelb")
in in_p