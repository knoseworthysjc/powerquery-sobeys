(oc, org, zones)=>
let
p_org=Text.Lower(org),
x = if org = "" or org = null or Text.Contains(oc, "Product Of") then oc 
else if Text.Contains(p_org, "canada") then org&" "&oc 
else if Text.Contains(p_org, "alberta") then org&" "&oc 
else if Text.Contains(p_org, "british columbia") then org&" "&oc 
else if Text.Contains(p_org, "manitoba") then org&" "&oc 
else if Text.Contains(p_org, "new brunswick") then org&" "&oc 
else if Text.Contains(p_org, "newfoundland") then org&" "&oc 
else if Text.Contains(p_org, "nova scotia") then org&" "&oc 
else if Text.Contains(p_org, "pei") then org&" "&oc 
else if Text.Contains(p_org, "saskatchewan") then org&" "&oc 
else oc&" "&org,
y = x,
z = if oc = null or oc = "" then oc else Text.Replace(Text.Combine(List.Select(Text.Split(Text.Replace(y,"#(lf)","|")," "),each Text.Contains(Text.Lower(_),".tif")=false and Text.Contains(Text.Lower(_),".eps")=false and Text.Contains(Text.Lower(_),".jpg")=false)," "),"|","#(lf)")
in if oc = null or oc = "" then oc else Text.Combine(List.Distinct(Text.Split(z,"#(lf)")),"#(lf)")