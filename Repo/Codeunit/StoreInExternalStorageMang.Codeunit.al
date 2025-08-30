codeunit 50100 "Store In External Storage Mang"
{
    Description = 'Manages sending files to external storage';
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reporting Triggers", GetFilename, '', false, false)]
    local procedure GetFilename(ReportID: Integer; Caption: Text[250]; ObjectPayload: JsonObject; FileExtension: Text[30]; ReportRecordRef: RecordRef; var FileName: Text; var Success: Boolean)
    begin
        // Check if the report is being downloaded
        if ObjectPayload.GetText('intent') = 'Download' then
            ReportFileName := FileName;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reporting Triggers", OnDocumentReady, '', false, false)]
    local procedure OnDocumentReady(ObjectId: Integer; ObjectPayload: JsonObject; DocumentStream: InStream; var TargetStream: OutStream; var Success: Boolean)
    var
        ExternalStorageSetup: Record "Store In External Storage Set.";
        ConfirmStoreFileQst: Label 'Do you want to store the file in External File Storage?';
    begin
        // Check if setup exists and is enabled
        if not ExternalStorageSetup.Get() then
            exit;

        if not ExternalStorageSetup."Enabled" then
            exit;

        // Only act if the intent is "Download"
        if ObjectPayload.GetText('intent') <> 'Download' then
            exit;

        // Ask user for confirmation using label
        if not Confirm(ConfirmStoreFileQst) then
            exit;

        // Save the file to external storage
        SaveInExternalStorage(DocumentStream, ReportFileName);
        Error('');
    end;


    internal procedure SaveInExternalStorage(Stream: InStream; FileName: Text)
    var
        StorageSetup: Record "Store In External Storage Set.";
        ExternalFileStorage: Codeunit "External File Storage";
        FullFilePath: Text;
        FileUploadedMsg: Label 'File "%1" uploaded successfully to external storage.', Comment = '%1 = File Path';
        UploadFailedErr: Label 'Failed to upload file "%1" to external storage.', Comment = '%1 = File Path';
        FileExistsErr: Label 'File "%1" already exists in external storage.', Comment = '%1 = File Path';
    begin
        // Exit if setup is missing or disabled
        if not StorageSetup.Get() or not StorageSetup."Enabled" then
            exit;

        // Ensure the store path is filled
        StorageSetup.TestField("Store Path");

        // Initialize External File Storage with the correct scenario
        ExternalFileStorage.Initialize(Enum::"File Scenario"::"Store In External Storage");

        // Combine path and formatted filename
        FullFilePath := ExternalFileStorage.CombinePath(StorageSetup."Store Path", GenerateFileName(FileName));

        // Truncate path if exceeding max length (optional, safety)
        FullFilePath := CopyStr(FullFilePath, 1, MaxStrLen(FullFilePath));

        // Create the file only if it does not exist
        if not ExternalFileStorage.FileExists(FullFilePath) then begin
            if ExternalFileStorage.CreateFile(FullFilePath, Stream) then
                Message(FileUploadedMsg, FullFilePath)
            else
                Message(UploadFailedErr, FullFilePath);
        end
        else
            Message(FileExistsErr, FullFilePath);
    end;


    local procedure GenerateFileName(OriginalFileName: Text): Text
    var
        StorageSetup: Record "Store In External Storage Set.";
        FileManagement: Codeunit "File Management";
        FormattedFileName: Text;
        FileExtension: Text;
        CurrentDT: DateTime;
    begin
        if not StorageSetup.Get() then
            exit(OriginalFileName);

        FileExtension := FileManagement.GetExtension(OriginalFileName);
        CurrentDT := CurrentDateTime();

        case StorageSetup."File Naming Convention" of
            StorageSetup."File Naming Convention"::Default:
                FormattedFileName := FileManagement.GetFileNameWithoutExtension(OriginalFileName);

            StorageSetup."File Naming Convention"::"Date (YYYYMMDD)":
                FormattedFileName := Format(Today, 0, '<yyyyMMdd>');

            StorageSetup."File Naming Convention"::"Date (DDMMYYYY)":
                FormattedFileName := Format(Today, 0, '<ddMMyyyy>');

            StorageSetup."File Naming Convention"::"Date (DDMMMYYYY)":
                FormattedFileName := Format(Today, 0, '<ddMMMyyyy>'); // e.g., 30Aug2025

            StorageSetup."File Naming Convention"::"Date (MMYYYY)":
                FormattedFileName := Format(Today, 0, '<MMyyyy>'); // e.g., 082025

            StorageSetup."File Naming Convention"::DateTime:
                FormattedFileName := Format(CurrentDT, 0, '<yyyyMMdd_HHmmss>');

            StorageSetup."File Naming Convention"::"Custom Pattern":
                FormattedFileName := ApplyCustomFilePattern(StorageSetup."Custom Pattern");
        end;

        // Combine prefix, main name, suffix, and extension
        FormattedFileName := StorageSetup."File Prefix" + FormattedFileName +
                             StorageSetup."File Suffix";

        if FileExtension <> '' then
            FormattedFileName := FormattedFileName + '.' + FileExtension;

        exit(FormattedFileName);
    end;


    local procedure ApplyCustomFilePattern(Pattern: Text): Text
    var
        ResultText: Text;
        CurrentDT: DateTime;
    begin
        ResultText := Pattern;
        CurrentDT := CurrentDateTime();

        // Replace standard placeholders with actual values
        ResultText := ResultText.Replace('{Date}', Format(Today(), 0, '<yyyyMMdd>'));
        ResultText := ResultText.Replace('{Date:DDMMYYYY}', Format(Today(), 0, '<ddMMyyyy>'));
        ResultText := ResultText.Replace('{Date:DDMMMYYYY}', Format(Today(), 0, '<ddMMMuuuu>'));
        ResultText := ResultText.Replace('{Date:MMYYYY}', Format(Today(), 0, '<MMyyyy>'));
        ResultText := ResultText.Replace('{Time}', Format(CurrentDT, 0, '<HHmmss>'));
        ResultText := ResultText.Replace('{DateTime}', Format(CurrentDT, 0, '<yyyyMMdd_HHmmss>'));

        exit(ResultText);
    end;


    var
        ReportFileName: Text;
}