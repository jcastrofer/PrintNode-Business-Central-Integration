table 50302 "PrintNode Printer Selection"
{
    DataClassification = ToBeClassified;
    Caption = 'Print Node Printer Selection';
    DrillDownPageId = "PrintNode Printer Selection";
    LookupPageId = "PrintNode Printer Selection";
    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.ValidateUserID("User ID");
            end;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }
        
        field(2; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type" = CONST (Report));
        }
        field(3; "Printer ID"; Code[20])
        {
            Caption = 'Printer ID';
            DataClassification = ToBeClassified;
            TableRelation = "PrintNode Printer"."Printer ID";
        }
        field(4; "Report Caption"; Text[250])
        {
            Caption = 'Report Caption';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE ("Object Type" = CONST (Report), "Object ID" = FIELD ("Report ID")));
        }
        field(5; "PrintJob Options "; text[250])
        {
            Caption = 'PrintJob Options ';
            DataClassification = ToBeClassified;
        }
        


    }

    keys
    {
        key(PK; "User ID", "Report ID")
        {
            Clustered = true;
        }
    }

}