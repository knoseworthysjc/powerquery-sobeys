let
    Source = (filename) => 
let 
Source = SharePoint.Contents("https://sjccontent.sharepoint.com/teams/WalmartContent/"),
    ClientHandoffs = Source{[Name="ClientHandoffs"]}[Content],
    Table = Table.SelectRows(ClientHandoffs,each [Name] = filename),
    #"Removed Columns" = Table.RemoveColumns(Table,{"Extension", "Date accessed", "Date modified", "Date created", "Folder Path"}),
    #"Expanded Attributes" = Table.ExpandRecordColumn(#"Removed Columns", "Attributes", {"Assigned_project"}, {"Assigned_project"}),
    #"Expanded Attributes.Assigned_project" = Table.ExpandRecordColumn(#"Expanded Attributes", "Assigned_project", {"Title", "Docket", "SeasonValue", "BannerValue", "Week", "Id"}, {"project", "Docket", "Season", "Banner", "Week", "project.Id"}),
    #"Added Custom" = Table.AddColumn(#"Expanded Attributes.Assigned_project", "excel", each Excel.Workbook([Content])),
    #"Expanded excel" = Table.ExpandTableColumn(#"Added Custom", "excel", {"Name", "Data", "Kind"}, {"excel.Name", "excel.Data", "excel.Kind"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded excel", each [excel.Kind] = "Sheet"),
    #"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"excel.Name", "tab"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns", "data", each Table.PromoteHeaders([excel.Data])),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Custom1",{"excel.Data"})
in
    #"Removed Columns1"
in
    Source