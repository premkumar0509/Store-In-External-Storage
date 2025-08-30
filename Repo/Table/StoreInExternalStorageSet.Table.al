table 50100 "Store In External Storage Set."
{
    Caption = 'Store In External Storage Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
            ToolTip = 'Unique identifier of this setup record. Automatically assigned or managed by the system.';
        }

        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = ToBeClassified;
            ToolTip = 'Specifies whether this setup is active. Only enabled setups will be used during file storage.';
        }

        field(3; "Store Path"; Text[2048])
        {
            Caption = 'Store Path';
            DataClassification = ToBeClassified;
            ToolTip = 'Defines the destination folder or path where files will be stored in the external storage system.';
        }

        field(4; "File Naming Convention"; Enum "File Naming Convention")
        {
            Caption = 'File Naming Convention';
            DataClassification = ToBeClassified;
            ToolTip = 'Specifies the format of the file name. Choose from predefined formats like Date, DateTime, or define a Custom Pattern.';
        }

        field(5; "Custom Pattern"; Text[100])
        {
            Caption = 'Custom Pattern';
            DataClassification = ToBeClassified;
            ToolTip = @'Define a custom naming pattern for the file.
                Use the following placeholders:
                    - {Date} → Current date in YYYYMMDD format (e.g., 20250830)
                    - {Date:DDMMYYYY} → Date in DDMMYYYY format (e.g., 30082025)
                    - {Date:DDMMMYYYY} → Date in DDMMMYYYY format (e.g., 30Aug2025)
                    - {Date:MMYYYY} → Date in MMYYYY format (e.g., 082025)
                    - {Time} → Current time in HHmmss format (e.g., 142315)
                    - {DateTime} → Date and time in YYYYMMDD_HHmmss format (e.g., 20250830_142315)
                    - {Seq} → Auto-incremented sequence number (e.g., 00001).

                Combine with prefix/suffix to build your own file name format.';
        }

        field(6; "File Prefix"; Text[50])
        {
            Caption = 'File Prefix';
            DataClassification = ToBeClassified;
            ToolTip = 'Optional static text to add at the beginning of the file name (e.g., "INV_" for invoices).';
        }

        field(7; "File Suffix"; Text[50])
        {
            Caption = 'File Suffix';
            DataClassification = ToBeClassified;
            ToolTip = 'Optional static text to add at the end of the file name before the extension (e.g., "_Final").';
        }

        field(8; "Default File Extension"; Text[10])
        {
            Caption = 'Default File Extension';
            DataClassification = ToBeClassified;
            ToolTip = 'Specifies the default file extension (e.g., PDF, TXT, CSV) when saving the file.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}