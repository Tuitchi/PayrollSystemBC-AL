page 50114 "Payroll File Card"
{
    PageType = Card;
    SourceTable = "Payroll File";
    Caption = 'Payroll File Card';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("Payroll File ID"; Rec."Payroll File ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll file ID.';
                    Importance = Promoted;
                }
                field("Department ID"; Rec."Department ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department ID.';
                    Importance = Promoted;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description.';
                    Importance = Promoted;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the payroll file.';
                    Importance = Promoted;
                }
            }

            group(Period)
            {
                Caption = 'Payroll Period';
                field("Payroll Period Start"; Rec."Payroll Period Start")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll period start date.';
                    Importance = Promoted;
                }
                field("Payroll Period End"; Rec."Payroll Period End")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll period end date.';
                    Importance = Promoted;
                }
            }

            group(Totals)
            {
                Caption = 'Totals';
                field("Total Employees"; Rec."Total Employees")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of employees in this payroll file.';
                }
            }

            group(Audit)
            {
                Caption = 'Audit Information';
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the created date.';
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who created this payroll file.';
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
                ToolTip = 'Save the payroll file.';

                trigger OnAction()
                begin
                    if Rec.Insert(true) then
                        Message('Payroll file saved successfully.')
                    else
                        if Rec.Modify(true) then
                            Message('Payroll file updated successfully.')
                        else
                            Error('Failed to save payroll file.');
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Payroll File ID" = '' then
            Error('Payroll File ID is required.');
    end;
}