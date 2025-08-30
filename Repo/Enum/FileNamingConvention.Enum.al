enum 50100 "File Naming Convention"
{
    Extensible = true;

    value(0; Default)
    {
        Caption = 'Default';
    }
    value(1; "Date (YYYYMMDD)")
    {
        Caption = 'Date (YYYYMMDD)';
    }
    value(2; "Date (DDMMYYYY)")
    {
        Caption = 'Date (DDMMYYYY)';
    }
    value(3; "Date (DDMMMYYYY)")
    {
        Caption = 'Date (DDMMMYYYY)';
    }
    value(4; "Date (MMYYYY)")
    {
        Caption = 'Date (MMYYYY)';
    }
    value(5; "DateTime")
    {
        Caption = 'DateTime (YYYYMMDD_HHmmss)';
    }
    value(6; "Custom Pattern")
    {
        Caption = 'Custom Pattern';
    }
}
