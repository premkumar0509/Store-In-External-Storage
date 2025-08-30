page 50100 "Store In External Storage Set."
{
    Caption = 'Store In External Storage Setup';
    SourceTable = "Store In External Storage Set.";
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enabled field.';
                }
                field("Store Path"; Rec."Store Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Store Path field.';
                    trigger OnAssistEdit()
                    begin
                        SelectExternalStoragePath(Rec."Store Path");
                    end;
                }
            }

            group(Naming)
            {
                Visible = Rec.Enabled;
                field("File Naming Convention"; Rec."File Naming Convention")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File Naming Convention field.';
                }
                field("Custom Pattern"; Rec."Custom Pattern")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Custom Pattern field.';
                }
                field("File Prefix"; Rec."File Prefix")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File Prefix field.';
                }
                field("File Suffix"; Rec."File Suffix")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File Suffix field.';
                }
                field("Default File Extension"; Rec."Default File Extension")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default File Extension field.';
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(Upload)
            {
                ApplicationArea = All;
                Caption = 'Upload';
                Image = MoveUp;
                ToolTip = 'Executes the Upload action.';
                trigger OnAction()
                var
                    StoreInExternalStorageMang: Codeunit "Store In External Storage Mang";
                    FromFilter, FileName : Text;
                    InStream: InStream;
                begin
                    FromFilter := 'All Files (*.*)|*.*';
                    UploadIntoStream(FromFilter, '', '', FileName, InStream);
                    StoreInExternalStorageMang.SaveInExternalStorage(InStream, FileName);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Upload_Promoted; Upload)
            {
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;


    internal procedure SelectExternalStoragePath(var FilePath: Text[2048])
    var
        ExternalFileStorage: Codeunit "External File Storage";
        SelectedFolder: Text;
    begin
        // Initialize with the correct file scenario
        ExternalFileStorage.Initialize(Enum::"File Scenario"::"Store In External Storage");

        SelectedFolder := ExternalFileStorage.SelectAndGetFolderPath(SelectedFolder);

        // Exit if no folder was selected
        if SelectedFolder = '' then
            exit;

        // Store the selected folder, respecting max length
        FilePath := CopyStr(SelectedFolder, 1, MaxStrLen(FilePath));
    end;

}