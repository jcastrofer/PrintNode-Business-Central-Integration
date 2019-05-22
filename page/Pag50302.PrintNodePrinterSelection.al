page 50302 "PrintNode Printer Selection"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "PrintNode Printer Selection";
    Caption = 'PrintNode Printer Selection';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Report ID"; "Report ID")
                {
                    ApplicationArea = All;
                }
                field("Printer ID"; "Printer ID")
                {
                    ApplicationArea = All;
                }
                field("Report Caption"; "Report Caption")
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

        }
    }
}