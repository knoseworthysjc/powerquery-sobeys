let 
p= if [#"price/non-weight_uom"] <> null then [#"price/non-weight_uom"]
else if [#"price/100g"] <> null then [#"price/100g"] else if [#"price/lb"] <> null then [#"price/lb"] else [#"price/kg"],
l = if p <> null then Text.Trim(Text.Combine(List.Sort(List.Distinct(List.RemoveNulls(List.Select(List.Transform(Text.Split(p,","),Text.Trim),each _ <> "")))),",")) else null,
r = Text.Lower([rewards_points]),
in_p = try if Text.Contains(r,"buy") and Text.Contains(r,"get") then "bogo"
else if Text.Contains(p,"/") and !Text.Contains(r,"pay") then "Multi_Buy"
else if Text.Contains(r,"pay") then "bmsm"
else if Text.Contains(r,"%") || Text.Contains(r,"off") then "Save %%"
else if Text.Contains(l,"/ea") then "price" 
else if [#"price/100g"] <> null and [#"price/100g"] <> "" then "price/100g"
else Text.Replace(Text.Lower([offer_type]),"price/kg","pricelb") otherwise Text.Replace(Text.Lower([offer_type]),"price/kg","pricelb")
in in_p