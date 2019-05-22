table 50300 "PrintNode Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'Print Node Setup';
    fields
    {
        field(1; "PK"; Code[10])
        {
            Caption = 'PK';
            DataClassification = ToBeClassified;
        }
        field(2; "PrintNode Account E-mail"; text[100])
        {
            Caption = 'Print Node Account E-mail';
            DataClassification = ToBeClassified;
        }
        field(3; "PrintNode API Key"; text[250])
        {
            Caption = 'PrintNode API Key';
            DataClassification = ToBeClassified;
        }
        field(4; "Enable PrintNode Integration"; Boolean)
        {
            Caption = 'Enable PrintNode Integration';
            DataClassification = ToBeClassified;
        }

        field(10; "PrintNode Base Endpoint"; Text[150])
        {
            Caption = 'PrintNode Base URI';
            DataClassification = ToBeClassified;
        }
        field(11; "PrintNode Printers Resource"; text[150])
        {
            Caption = 'PrintNode Printers Resource';
            DataClassification = ToBeClassified;
        }
        field(12; "PrintNode PrintJob Resource"; Text[150])
        {
            Caption = 'PrintNode PrintJob Resource';
            DataClassification = ToBeClassified;
        }



    }

    keys
    {
        key(PK; "PK")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    begin
        if not get then begin
            Init();
            "PrintNode Base Endpoint" := 'https://api.printnode.com';
            "PrintNode Printers Resource" := '/printers';
            "PrintNode PrintJob Resource" := '/printjobs';

            Insert();
        end;
    end;
}