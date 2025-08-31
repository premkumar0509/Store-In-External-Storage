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
                }
                field("Store Path"; Rec."Store Path")
                {
                    ApplicationArea = All;
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
                }
                field("Custom Pattern"; Rec."Custom Pattern")
                {
                    ApplicationArea = All;
                }
                field("File Prefix"; Rec."File Prefix")
                {
                    ApplicationArea = All;
                }
                field("File Suffix"; Rec."File Suffix")
                {
                    ApplicationArea = All;
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