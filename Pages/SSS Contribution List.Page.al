page 50104 "SSS Contribution List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SSS Contribution";
    Caption = 'SSS Contribution Table';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("LowRate"; Rec."LowRate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum salary in the range.';
                }
                field("HighRate"; Rec."HighRate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum salary in the range.';
                }
                field("MSC"; Rec."MSC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Monthly Salary Credit for this salary range.';
                }
                field("EmployeeShare"; Rec."EmployeeShare")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee share of the SSS contribution.';
                }
                field("EmployerShare"; Rec."EmployerShare")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employer share of the SSS contribution.';
                }
                field("ECC"; Rec."ECC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employer EC contribution.';
                }
                field("TotalContribution"; Rec."TotalContribution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total contribution amount.';
                }
                field("EffectiveDate"; Rec."EffectiveDate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date from which these contribution rates are effective.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportSSS)
            {
                ApplicationArea = All;
                Caption = 'Import SSS Table';
                ToolTip = 'Import the latest SSS contribution table from Excel.';
                Image = ImportExcel;

                trigger OnAction()
                var
                    SSSImport: Codeunit 50104;
                begin
                    SSSImport.ImportSSSTable();
                end;
            }
        }
    }
}