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
                field("Default Printer ID"; "Default Printer ID")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Default Printer Name"; "Default Printer Name")
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
                    PrintNodeMgt: Codeunit "PrintNode Management";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.setrange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.FindFirst();
                    PrintNodeMgt.SendReportToPrintNode(report::"Order Confirmation", SalesHeader, format(SalesHeader."Document Type") + '-' + SalesHeader."No.");
                end;
            }
            action(OpenEmailWeb)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Web;
                Caption = 'Open PrintNode E-mail Setup';

                trigger OnAction();
                begin
                    Hyperlink('https://app.printnode.com/email');
                end;
            }
            action(OpenAPIKeysSite)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Web;
                Caption = 'Open PrintNode API Keys';

                trigger OnAction();
                begin
                    Hyperlink('https://app.printnode.com/apikeys');
                end;
            }
            action(GetPrinters)
            {
                ApplicationArea = All;
                Caption = 'Get PrintNode Printers';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Print;
                trigger OnAction()
                var
                    PrintNodeMgt: Codeunit "PrintNode Management";
                begin
                    PrintNodeMgt.GetPrinters();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        InsertIfNotExists();
    end;

}
