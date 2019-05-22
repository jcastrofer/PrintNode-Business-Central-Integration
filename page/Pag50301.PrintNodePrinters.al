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
            action(OpenEmailWeb)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Web;
                Caption = 'Open PrintNode E-mail Setup';

                trigger OnAction();
                begin
                    Hyperlink('https://app.printnode.com/email');
                end;
            }

        }
    }
}