page 50301 "PrintNode Printers"
{
    PageType = List;
    Caption = 'PrintNode Printers';
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "PrintNode Printer";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Printer ID"; "Printer ID")
                {
                    ApplicationArea = All;
                }

                field("Printer Name"; "Printer Name")
                {
                    ApplicationArea = All;
                }
                field(State; State)
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
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
                    CurrPage.Update();
                end;
            }
        }
    }
}