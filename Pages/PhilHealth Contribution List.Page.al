page 50106 "PhilHealth Contribution List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PhilHealth Contribution";
    Caption = 'PhilHealth Contribution Table';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("MinSalary"; Rec."LowRate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum monthly basic salary in the range.';
                }
                field("MaxSalary"; Rec."HighRate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum monthly basic salary in the range.';
                }
                field("PremiumRate"; Rec."PremiumRate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the premium rate percentage for this salary range.';
                }
                field("EmployeeShare"; Rec."EmployeeShare")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee share of the PhilHealth contribution.';
                }
                field("EmployerShare"; Rec."EmployerShare")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employer share of the PhilHealth contribution.';
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
            action(ImportPhilHealth)
            {
                ApplicationArea = All;
                Caption = 'Import PhilHealth Table';
                ToolTip = 'Import the latest PhilHealth contribution table from Excel.';
                Image = ImportExcel;

                trigger OnAction()
                var
                    PhilHealthImport: Codeunit "PhilHealth Import";
                begin
                    PhilHealthImport.ImportPhilHealthTable();
                end;
            }
        }
    }
}