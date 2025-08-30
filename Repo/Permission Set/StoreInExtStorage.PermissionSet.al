permissionset 50100 "Store In Ext Storage"
{
    Caption = 'Store In External Storage';

    Assignable = true;
    Permissions = tabledata "Store In External Storage Set." = RIMD,
                  table "Store In External Storage Set." = X,
                  codeunit "Store In External Storage Mang" = X;
}