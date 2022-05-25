let
    Source = SharePoint.Files("https://sjccontent.sharepoint.com/teams/InformationServices", [ApiVersion = 15]),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "WorkSpaces.json") and ([Folder Path] <> "https://sjccontent.sharepoint.com/teams/InformationServices/Shared Documents/ProofHQ Reports/")),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"Extension", "Date accessed", "Date modified", "Date created", "Attributes", "Folder Path"}),
    #"Added Custom" = Table.AddColumn(#"Removed Columns", "Data", each Json.Document([Content],TextEncoding.Utf8)),
    Data = #"Added Custom"{0}[Data],
    #"SOAP-ENV:Envelope" = Data[#"SOAP-ENV:Envelope"],
    #"SOAP-ENV:Body" = #"SOAP-ENV:Envelope"[#"SOAP-ENV:Body"],
    #"ns1:getWorkspacesResponse" = #"SOAP-ENV:Body"[#"ns1:getWorkspacesResponse"],
    result = #"ns1:getWorkspacesResponse"[result],
    item = result[item],
    #"Converted to Table" = Table.FromList(item, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "root_level", "description", "client", "project", "personal", "owner_id", "parent_workspace_id"}, {"id", "name", "root_level", "description", "client", "project", "personal", "owner_id", "parent_workspace_id"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",{{"id", Int64.Type}, {"owner_id", Int64.Type}, {"parent_workspace_id", Int64.Type}, {"root_level", Int64.Type}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Changed Type", "id", "id - Copy"),
    #"Renamed Columns" = Table.RenameColumns(#"Duplicated Column",{{"id - Copy", "workspace_id"}})
in
    #"Renamed Columns"