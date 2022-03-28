(zonesorg, banner,page,position) => 
let 
in_nfld = if Text.Contains(zonesorg, "MARM") and Text.Contains(zonesorg,"NFLD") = false then Table.RowCount(Table.SelectRows(nfld,each [page] = page and [position] = position)) else 0,
AB = if Text.Contains(zonesorg,"AB") or Text.Contains(zonesorg,"WEST") or (banner="IGA" and Text.Contains(zonesorg,"NTL")) then "{'Id':21}" else null,
BC = if Text.Contains(zonesorg,"BC") or Text.Contains(zonesorg,"WEST") or banner="Thrifty Foods" or (banner="IGA" and Text.Contains(zonesorg,"NTL")) then "{'Id':20}" else null,
MB = if Text.Contains(zonesorg,"MB") or Text.Contains(zonesorg,"WEST") or (banner="IGA" and Text.Contains(zonesorg,"NTL")) then "{'Id':20}" else null,
NB = if Text.Contains(zonesorg,"MARM") or Text.Contains(zonesorg,"NB") then "{'Id':'24'}" else null,
NFLD = if (Text.Contains(zonesorg,"MARM") and in_nfld = 0) or Text.Contains(zonesorg,"NFLD") then "{'Id':'26'}" else null,
NS = if Text.Contains(zonesorg,"MARM") or Text.Contains(zonesorg,"NS") then "{'Id':'25'}" else null,
ONT = if Text.Contains(zonesorg,"ONT") or (banner="IGA" and Text.Contains(zonesorg,"NTL")) then "{'Id':15}" else null,
PEI = if Text.Contains(zonesorg,"MARM") or Text.Contains(zonesorg,"PEI") then "{'Id':'27'}" else null,
SK = if Text.Contains(zonesorg,"SK") or Text.Contains(zonesorg,"WEST") or (banner="IGA" and Text.Contains(zonesorg,"NTL")) then "{'Id':22}" else null
in "["&Text.Combine(List.RemoveNulls({AB,BC,MB,NB,NFLD,NS,ONT,PEI,SK}),",")&"]"