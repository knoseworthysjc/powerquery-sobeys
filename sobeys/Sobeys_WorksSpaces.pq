let
    Source = ProofHqWorkSpaces,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"id", "name", "root_level"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each ([root_level] = 1) and ([name] = "Sobeys")),
    #"Merged Queries" = Table.NestedJoin(#"Filtered Rows", {"id"}, ProofHqWorkSpaces, {"parent_workspace_id"}, "ProofHqWorkSpaces", JoinKind.LeftOuter),
    #"Expanded ProofHqWorkSpaces" = Table.ExpandTableColumn(#"Merged Queries", "ProofHqWorkSpaces", {"id", "name"}, {"ProofHqWorkSpaces.id", "ProofHqWorkSpaces.name"}),
    #"Filtered Rows1" = Table.SelectRows(#"Expanded ProofHqWorkSpaces", each ([ProofHqWorkSpaces.name] = "Weekly_Flyers")),
    #"Merged Queries1" = Table.NestedJoin(#"Filtered Rows1", {"ProofHqWorkSpaces.id"}, ProofHqWorkSpaces, {"parent_workspace_id"}, "ProofHqWorkSpaces", JoinKind.LeftOuter),
    #"Expanded ProofHqWorkSpaces1" = Table.ExpandTableColumn(#"Merged Queries1", "ProofHqWorkSpaces", {"id", "name"}, {"ProofHqWorkSpaces.id.1", "ProofHqWorkSpaces.name.1"}),
    #"Filtered Rows3" = Table.SelectRows(#"Expanded ProofHqWorkSpaces1", each ([ProofHqWorkSpaces.name.1] <> "POS" and [ProofHqWorkSpaces.name.1] <> "Weekly_Creative_Review" and [ProofHqWorkSpaces.name.1] <> "Weekly_WallWalk")),
    #"Merged Queries2" = Table.NestedJoin(#"Filtered Rows3", {"ProofHqWorkSpaces.id.1"}, ProofHqWorkSpaces, {"parent_workspace_id"}, "ProofHqWorkSpaces", JoinKind.LeftOuter),
    #"Expanded ProofHqWorkSpaces2" = Table.ExpandTableColumn(#"Merged Queries2", "ProofHqWorkSpaces", {"id", "name"}, {"ProofHqWorkSpaces.id.2", "ProofHqWorkSpaces.name.2"}),
    #"Merged Queries3" = Table.NestedJoin(#"Expanded ProofHqWorkSpaces2", {"ProofHqWorkSpaces.id.2"}, ProofHqWorkSpaces, {"parent_workspace_id"}, "ProofHqWorkSpaces", JoinKind.LeftOuter),
    #"Expanded ProofHqWorkSpaces3" = Table.ExpandTableColumn(#"Merged Queries3", "ProofHqWorkSpaces", {"id", "name"}, {"ProofHqWorkSpaces.id.3", "ProofHqWorkSpaces.name.3"}),
    #"Merged Queries4" = Table.NestedJoin(#"Expanded ProofHqWorkSpaces3", {"ProofHqWorkSpaces.id.3"}, ProofHqWorkSpacesTier1, {"parent_workspace_id"}, "ProofHqWorkSpaces", JoinKind.LeftOuter),
    #"Expanded ProofHqWorkSpaces4" = Table.ExpandTableColumn(#"Merged Queries4", "ProofHqWorkSpaces", {"id", "name"}, {"ProofHqWorkSpaces.id.4", "ProofHqWorkSpaces.name.4"}),
    #"Merged Columns" = Table.CombineColumns(Table.TransformColumnTypes(#"Expanded ProofHqWorkSpaces4", {{"id", type text}, {"ProofHqWorkSpaces.id", type text}, {"ProofHqWorkSpaces.id.1", type text}, {"ProofHqWorkSpaces.id.2", type text},{"ProofHqWorkSpaces.id.3", type text},{"ProofHqWorkSpaces.id.4", type text}}, "en-US"),{"id", "ProofHqWorkSpaces.id", "ProofHqWorkSpaces.id.1", "ProofHqWorkSpaces.id.2","ProofHqWorkSpaces.id.3","ProofHqWorkSpaces.id.4"},Combiner.CombineTextByDelimiter("/", QuoteStyle.None),"Merged"),
    #"Duplicated Column" = Table.DuplicateColumn(#"Merged Columns", "ProofHqWorkSpaces.name.1", "ProofHqWorkSpaces.name.1 - Copy"),
    #"Renamed Columns" = Table.RenameColumns(#"Duplicated Column",{{"ProofHqWorkSpaces.name.1 - Copy", "banner"}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Renamed Columns",{"banner", "name", "root_level", "ProofHqWorkSpaces.name", "ProofHqWorkSpaces.name.1", "Merged", "ProofHqWorkSpaces.name.2", "ProofHqWorkSpaces.name.3"}),
    #"Merged Columns1" = Table.CombineColumns(#"Reordered Columns",{"name", "ProofHqWorkSpaces.name", "ProofHqWorkSpaces.name.1", "ProofHqWorkSpaces.name.2", "ProofHqWorkSpaces.name.3","ProofHqWorkSpaces.name.4"},Combiner.CombineTextByDelimiter("/", QuoteStyle.None),"Merged.1"),
    #"Renamed Columns1" = Table.RenameColumns(#"Merged Columns1",{{"Merged.1", "path"}, {"Merged", "ids"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns1",{"root_level"}),
    #"Added Custom" = Table.AddColumn(#"Removed Columns", "workspace_id", each List.Last(List.Select(Text.Split([ids],"/"), each _ <> ""))),
    #"Added Custom1" = Table.AddColumn(#"Added Custom", "workspace", each List.Last(List.Select(Text.Split([path],"/"), each _ <> ""))),
    #"Reordered Columns1" = Table.ReorderColumns(#"Added Custom1",{"banner", "workspace", "ids", "path", "workspace_id"}),
    #"Replaced Value" = Table.ReplaceValue(#"Reordered Columns1","&amp;","&",Replacer.ReplaceText,{"banner", "workspace"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Replaced Value",{"ids"}),
    #"Reordered Columns2" = Table.ReorderColumns(#"Removed Columns1",{"banner", "workspace", "workspace_id", "path"}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Reordered Columns2", "workspace", "workspace - Copy"),
    #"Replaced Value1" = Table.ReplaceValue(#"Duplicated Column1"," ","_",Replacer.ReplaceText,{"workspace - Copy"}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Replaced Value1", "workspace - Copy", Splitter.SplitTextByDelimiter("_", QuoteStyle.Csv), {"workspace - Copy.1", "workspace - Copy.2"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Split Column by Delimiter",{{"workspace - Copy.1", "docket"}}),
    #"Reordered Columns3" = Table.ReorderColumns(#"Renamed Columns2",{"docket", "banner", "workspace", "workspace_id", "path", "workspace - Copy.2"}),
    #"Uppercased Text" = Table.TransformColumns(#"Reordered Columns3",{{"workspace - Copy.2", Text.Upper, type text}}),
    #"Replaced Value2" = Table.ReplaceValue(#"Uppercased Text","WK","",Replacer.ReplaceText,{"workspace - Copy.2"}),
    #"Trimmed Text" = Table.TransformColumns(#"Replaced Value2",{{"workspace - Copy.2", Text.Trim, type text}}),
    #"Added Custom3" = Table.AddColumn(#"Trimmed Text", "Week", each Text.PadStart([#"workspace - Copy.2"],2,"0")),
    #"Reordered Columns4" = Table.ReorderColumns(#"Added Custom3",{"banner", "Week", "workspace", "docket", "workspace_id", "path"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Reordered Columns4",{{"workspace_id", Int64.Type}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Changed Type",{"workspace - Copy.2"}),
    #"Added Custom2" = Table.AddColumn(#"Removed Columns2", "year", each List.Last(Text.Split([workspace],"_"))),
    #"Reordered Columns5" = Table.ReorderColumns(#"Added Custom2",{"year", "banner", "Week", "workspace", "docket", "workspace_id", "path"})
in
    #"Reordered Columns5"