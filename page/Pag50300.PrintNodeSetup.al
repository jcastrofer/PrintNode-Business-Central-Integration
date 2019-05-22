page 50300 "PrintNode Setup"
{

    PageType = Card;
    SourceTable = "PrintNode Setup";
    Caption = 'PrintNode Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(General)
            {

                field("Enable PrintNode Integration"; "Enable PrintNode Integration")
                {
                    ApplicationArea = All;
                }

                field("PrintNode Account E-mail"; "PrintNode Account E-mail")
                {
                    ApplicationArea = All;
                }
                field("PrintNode API Key"; "PrintNode API Key")
                {
                    ApplicationArea = All;
                }



            }
            group(Endpoints)
            {
                field("PrintNode Base Endpoint"; "PrintNode Base Endpoint")
                {
                    ApplicationArea = All;
                }

                field("PrintNode Printers Resource"; "PrintNode Printers Resource")
                {
                    ApplicationArea = All;
                }
                field("PrintNode PrintJob Resource"; "PrintNode PrintJob Resource")
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
            action(test)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    PrintNodeMgt: Codeunit "Print Node Management";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.setrange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.FindFirst();
                    PrintNodeMgt.SendReportToPrintNode(report::"Order Confirmation", SalesHeader, format(SalesHeader."Document Type") + '-' + SalesHeader."No.");
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        InsertIfNotExists();
    end;

}
