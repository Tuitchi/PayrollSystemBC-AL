page 50110 "Shift List"
{
    PageType = List;
    SourceTable = Shift;
    Caption = 'Shift List';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Shift Code"; Rec."Shift Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift code.';
                }
                field("Shift Name"; Rec."Shift Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift name.';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift start time.';
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift end time.';
                }
                field("Working Hours"; Rec."Working Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total working hours for this shift.';
                }
                field("Is Active"; Rec."Is Active")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this shift is active.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift description.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewShift)
            {
                ApplicationArea = All;
                Caption = 'New Shift';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Create a new shift.';

                trigger OnAction()
                var
                    ShiftCard: Page "Shift Card";
                begin
                    ShiftCard.RunModal();
                end;
            }
        }
    }
}