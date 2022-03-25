let
Source = Excel.CurrentWorkbook(){[Name="rawdata"]}[Content],
    #"Changed Type1" = Table.TransformColumnTypes(Source,{{"price/kg", type text}, {"price/lb", type text}, {"price/100g", type text}, {"price/non-weight_uom", type text}}),
    #"Replaced Value4" = Table.ReplaceValue(#"Changed Type1","",null,Replacer.ReplaceValue,{"price/kg","price/100g","price/non-weight_uom","price/lb"}),
    #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","/ea","",Replacer.ReplaceText,{"price/kg","price/100g","price/non-weight_uom","price/lb"}),
    #"Removed Columns2" = Table.RemoveColumns(#"Replaced Value5",{"zones"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Removed Columns2",{"measure", "title", "updated_by", "pagelayout", "pgx", "pgy", "flyerpage", "flyerpageid", "id"}),
    #"Removed Columns3" = Table.RemoveColumns(#"Removed Columns1",{"modified"}),
    #"Removed Columns5" = Table.RemoveColumns(#"Removed Columns3",{"offer_copy_fre"}),
    #"Replaced Value" = Table.ReplaceValue(#"Removed Columns5","<MISSING IMAGE>",null,Replacer.ReplaceValue,{"image1","image2","image3","image4","image5","image6","image7"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","",null,Replacer.ReplaceValue,{"image1","image2","image3","image4","image5","image6","image7","price/lb","price/kg","price/100g","offer_copy","product_origin","price/non-weight_uom"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Replaced Value1",{{"promo_start", type date}, {"promo_end", type date}}),
    #"Replaced Value2" = Table.ReplaceValue(#"Changed Type","<MISSING IMAGE>","",Replacer.ReplaceText,{"image1", "image2", "image3", "image4", "image5", "image6", "image7"}),
    #"Trimmed Text" = Table.TransformColumns(#"Replaced Value2",{{"image1", Text.Trim, type text}, {"image2", Text.Trim, type text}, {"image3", Text.Trim, type text}, {"image4", Text.Trim, type text}, {"image5", Text.Trim, type text}, {"image6", Text.Trim, type text}, {"image7", Text.Trim, type text}}),
    #"Replaced Value3" = Table.ReplaceValue(#"Trimmed Text","",null,Replacer.ReplaceValue,{"image1", "image2", "image3", "image4", "image5", "image6", "image7"}),
    image_org = Table.AddColumn(#"Replaced Value3", "image_org", each Text.Trim(Text.Replace(Text.Combine(List.Distinct(List.Sort(List.RemoveNulls({[image1],[image2]}))),"#(lf)"),"<MISSING IMAGE>",""))),
    price_a = Table.AddColumn(image_org, "price_a", each getPrice([#"price/non-weight_uom"],[#"price/100g"],[#"price/kg"],[#"price/lb"])),
    price_b = Table.AddColumn(price_a, "price_b", each let 
p = if [#"price/lb"] <> null then [#"price/kg"] else null,
l = if p <> null then Text.Combine(List.Sort(List.Distinct(List.Transform(Text.Split(p,","),Text.Trim))),",") else null
in l),
    #"Removed Columns" = Table.RemoveColumns(price_b,{"image1", "image2", "image3", "image4", "image5", "image6", "image7"}),
    #"Added Custom13" = Table.AddColumn(#"Removed Columns", "new_offertype", each let 
p= if [#"price/non-weight_uom"] <> null then [#"price/non-weight_uom"]
else if [#"price/100g"] <> null then [#"price/100g"] else if [#"price/lb"] <> null then [#"price/lb"] else [#"price/kg"],
l = if p <> null then Text.Trim(Text.Combine(List.Sort(List.Distinct(List.RemoveNulls(List.Select(List.Transform(Text.Split(p,","),Text.Trim),each _ <> "")))),",")) else null,
r = Text.Lower([rewards_points]),
in_p = try if Text.Contains(r,"buy") and Text.Contains(r,"get") then "bogo"
else if Text.Contains(p,"/") and Text.Contains(r,"pay") = false then "Multi_Buy"
else if Text.Contains(r,"pay") then "bmsm"
else if Text.Contains(r,"%") or Text.Contains(r,"off") then "Save %%"
else if Text.Contains(l,"/ea") then "price" 
else if [#"price/100g"] <> null and [#"price/100g"] <> "" then "price/100g"
else Text.Replace(Text.Lower([offer_type]),"price/kg","pricelb") otherwise Text.Replace(Text.Lower([offer_type]),"price/kg","pricelb")
in in_p),
    #"Grouped Rows" = Table.Group(#"Added Custom13", {"project.Id", "page", "position", "product_origin", "offer_copy", "price_a", "price_b", "image_org", "Banner", "Season", "Week"}, {{"Count", each Table.RowCount(_), Int64.Type}, {"Data", each _, type table [file=text, project=text, project.Id=text, tab=text, docket=nullable text, Banner=nullable text, Season=any, Week=any, promo_start=nullable date, promo_end=nullable date, project.1=nullable text, page=any, folio=nullable number, position=nullable number, itemnumber=nullable text, category=nullable text, product_origin=nullable text, offer_copy=nullable text, offer_layout=any, offer_type=nullable text, #"price/kg"=nullable text, #"price/lb"=nullable text, #"price/100g"=any, #"price/non-weight_uom"=nullable text, rewards_points=nullable text, assigned_logo=nullable text, assigned_icon=nullable text, instructions=nullable text, image_org=text, price_a=nullable text, price_b=nullable text]}}),
    #"Added Custom3" = Table.AddColumn(#"Grouped Rows", "copy", each if [offer_copy] <> null and [offer_copy] <> "" then Text.Proper(Text.Combine(List.Distinct(List.RemoveNulls(List.Transform(Text.Split([offer_copy],"#(lf)"),Text.Trim))),"#(lf)")) else null),
    #"Removed Columns4" = Table.RemoveColumns(#"Added Custom3",{"offer_copy"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Columns4",{"project.Id", "Banner", "Season", "Week", "page", "position", "product_origin", "copy", "price_a", "price_b", "image_org", "Count", "Data"}),
    #"Added Custom4" = Table.AddColumn(#"Reordered Columns", "origin", each if [product_origin] <> null and [product_origin] <> "" then Text.Proper(Text.Combine(List.Distinct(List.RemoveNulls(List.Transform(Text.Split([product_origin],"#(lf)"),Text.Trim))),"#(lf)")) else null),
    #"Reordered Columns1" = Table.ReorderColumns(#"Added Custom4",{"project.Id", "Banner", "Season", "Week", "page", "position", "product_origin", "origin", "copy", "price_a", "price_b", "image_org", "Count", "Data"}),
    #"Removed Columns6" = Table.RemoveColumns(#"Reordered Columns1",{"product_origin"}),
    zones_org = Table.AddColumn(#"Removed Columns6", "zones_org", each Text.Combine(List.Distinct(Table.Column([Data],"tab")),",")),
    zones = Table.AddColumn(zones_org, "zones", each getZones([zones_org],[Banner])),
    #"Added Custom8" = Table.AddColumn(zones, "item_number", each Text.Combine(List.Distinct(List.Select(Text.Split(Text.Replace(Text.Combine(Table.Column([Data],"itemnumber"),"#(lf)"),",","#(lf)"),"#(lf)"),each _ <> "" and _ <> null)),",")),
    #"Reordered Columns2" = Table.ReorderColumns(#"Added Custom8",{"project.Id", "Banner", "Season", "Week", "page", "position", "origin", "copy", "price_a", "price_b", "item_number", "image_org", "Count", "Data", "zones_org", "in_nfld", "zones"}),
    #"Added Custom9" = Table.AddColumn(#"Reordered Columns2", "offer_type", each Text.Combine(List.Distinct(Table.Column([Data],"offer_type")),",")),
    #"Reordered Columns3" = Table.ReorderColumns(#"Added Custom9",{"project.Id", "Banner", "Season", "Week", "page", "position", "origin", "copy", "offer_type", "price_a", "price_b", "item_number", "image_org", "Count", "Data", "zones_org", "in_nfld", "zones"}),
    #"Added Custom10" = Table.AddColumn(#"Reordered Columns3", "rewards_points", each try Text.Trim(Text.Split(Text.Combine(List.Distinct(List.Select(List.Transform(Table.Column([Data],"rewards_points"),each Text.Replace(_,"#(lf)","-")), each _ <> "" and _ <> null)),"#(lf)"),"-"){1}) otherwise null),
    #"Added Custom11" = Table.AddColumn(#"Added Custom10", "instructions", each Text.Combine(List.Distinct(Table.Column([Data],"instructions")),"#(lf)")),
    Images = Table.AddColumn(#"Added Custom11", "images", each getImages(Text.Split([image_org],"#(lf)"))),
    #"Added Index" = Table.AddIndexColumn(Images, "Index", 0, 1, Int64.Type),
    #"Filtered Rows" = Table.SelectRows(#"Added Index", each ([page] <> null)),
    #"Added Custom14" = Table.AddColumn(#"Filtered Rows", "new_offertype", each Text.Combine(List.Distinct(List.RemoveNulls(Text.Split(Text.Combine(List.Distinct(Table.Column([Data],"new_offertype")),","),","))),",")),
    #"Added Custom15" = Table.AddColumn(#"Added Custom14", "assigned_logo", each Text.Combine(List.Distinct(Table.Column([Data],"assigned_logo")),",")),
    #"Added Custom16" = Table.AddColumn(#"Added Custom15", "assigned_icon", each Text.Combine(List.Distinct(Table.Column([Data],"assigned_icon")),",")),
    #"Added Custom17" = Table.AddColumn(#"Added Custom16", "category", each Text.Combine(List.Distinct(Text.Split(Text.Combine(List.Distinct(Table.Column([Data],"category")),","),",")),","))
in
    #"Added Custom17"