page 50111 "Shift Card"
{
    PageType = Card;
    SourceTable = Shift;
    Caption = 'Shift Card';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("Shift Code"; Rec."Shift Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift code.';
                    Importance = Promoted;
                }
                field("Shift Name"; Rec."Shift Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift name.';
                    Importance = Promoted;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift description.';
                }
                field("Is Active"; Rec."Is Active")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this shift is active.';
                }
            }

            group(TimeSchedule)
            {
                Caption = 'Time Schedule';
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift start time.';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        CalculateWorkingHours();
                    end;
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift end time.';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        CalculateWorkingHours();
                    end;
                }
                field("Working Hours"; Rec."Working Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total working hours for this shift.';
                    Importance = Promoted;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Save)
            {
                ApplicationArea = All;
                Caption = 'Save';
                Image = Save;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Save the shift.';

                trigger OnAction()
                begin
                    if Rec.Insert(true) then
                        Message('Shift saved successfully.')
                    else
                        if Rec.Modify(true) then
                            Message('Shift updated successfully.')
                        else
                            Error('Failed to save shift.');
                end;
            }
            action(CalculateHours)
            {
                ApplicationArea = All;
                Caption = 'Calculate Hours';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Calculate working hours based on start and end time.';

                trigger OnAction()
                begin
                    CalculateWorkingHours();
                    Message('Working hours calculated: %1 hours', Rec."Working Hours");
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Shift Code" = '' then
            Error('Shift Code is required.');
        Rec."Is Active" := true;
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateWorkingHours();
    end;

    local procedure CalculateWorkingHours()
    var
        Duration: Duration;
        WorkingHours: Decimal;
    begin
        if (Rec."Start Time" = 0T) or (Rec."End Time" = 0T) then begin
            Rec."Working Hours" := 0;
            exit;
        end;

        // Calculate duration
        Duration := Rec."End Time" - Rec."Start Time";

        // Handle overnight shifts (negative duration means overnight)
        if Duration < 0 then
            Duration := Duration + 86400000; // Add 24 hours in milliseconds

        // Convert duration to hours (milliseconds to hours)
        WorkingHours := Duration / 3600000; // 3600000 = 60 * 60 * 1000

        // Round to 2 decimal places
        Rec."Working Hours" := Round(WorkingHours, 0.01);
    end;
}