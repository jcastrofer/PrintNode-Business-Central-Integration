table 50301 "PrintNode Printer"
{
    DataClassification = ToBeClassified;
    Caption = 'Print Node Printers';
    LookupPageId = "PrintNode Printers";
    DrillDownPageId = "PrintNode Printers";
    fields
    {
        field(1; "Printer Name"; text[250])
        {
            Caption = 'Printer Name';
            DataClassification = ToBeClassified;
        }
        field(2; "E-mail Address"; Text[250])
        {
            Caption = 'E-mail Address';
            DataClassification = ToBeClassified;
        }
        field(3; "Printer ID"; Code[20])
        {
            Caption = 'ID';
            DataClassification = ToBeClassified;
        }
        field(4; "State"; Text[100])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Printer ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Dropdown; "Printer ID", "Printer Name")
        {

        }
    }
}