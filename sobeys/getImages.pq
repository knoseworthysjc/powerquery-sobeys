(imagelist as list)=>
let
    x = "["&Text.Combine(List.Transform(List.RemoveNulls(Table.Column(Table.ExpandTableColumn(Table.AddColumn(Table.FromList(imagelist),"images", each let c = [Column1] in Table.SelectRows(images, each [Title] = c)),"images",{"Id","Title"}),"Id")),each "{'ID':"&Text.From(_)&"}"),",")&"]"
in x