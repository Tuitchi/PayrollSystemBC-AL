page 50101 "PH Payroll Setup"
{
    ApplicationArea = All;
    Caption = 'Payroll Setup';
    PageType = Card;
    SourceTable = "PH Payroll Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(Default_Working_Hours; Rec.Default_Working_Hours)
                {
                    ToolTip = 'Specifies the default number of working hours per day.';
                }
                field(Default_Working_Days; Rec.Default_Working_Days)
                {
                    ToolTip = 'Specifies the default number of working days per month.';
                }
            }

            group("Mandatory Contributions")
            {
                Caption = 'Mandatory Contributions';

                field(SSS_Contribution_Pct; Rec.SSS_Contribution_Pct)
                {
                    ToolTip = 'Specifies the percentage for SSS contributions.';
                }
                field(PagIBIG_Contribution_Pct; Rec.PagIBIG_Contribution_Pct)
                {
                    ToolTip = 'Specifies the percentage for Pag-IBIG contributions.';
                }
                field(PhilHealth_Contribution_Pct; Rec.PhilHealth_Contribution_Pct)
                {
                    ToolTip = 'Specifies the percentage for PhilHealth contributions.';
                }
            }

            group("Tax Brackets")
            {
                Caption = 'Tax Brackets';

                field("Tax Bracket 1 Max"; Rec.Tax_Bracket1_Max)
                {
                    ToolTip = 'Specifies the maximum amount for tax bracket 1.';
                }
                field("Tax Rate 1"; Rec.Tax_Rate1)
                {
                    ToolTip = 'Specifies the tax rate for bracket 1.';
                }
                field("Tax Bracket 2 Max"; Rec.Tax_Bracket2_Max)
                {
                    ToolTip = 'Specifies the maximum amount for tax bracket 2.';
                }
                field("Tax Rate 2"; Rec.Tax_Rate2)
                {
                    ToolTip = 'Specifies the tax rate for bracket 2.';
                }
                field("Tax Bracket 3 Max"; Rec.Tax_Bracket3_Max)
                {
                    ToolTip = 'Specifies the maximum amount for tax bracket 3.';
                }
                field("Tax Rate 3"; Rec.Tax_Rate3)
                {
                    ToolTip = 'Specifies the tax rate for bracket 3.';
                }
                field("Tax Bracket 4 Max"; Rec.Tax_Bracket4_Max)
                {
                    ToolTip = 'Specifies the maximum amount for tax bracket 4.';
                }
                field("Tax Rate 4"; Rec.Tax_Rate4)
                {
                    ToolTip = 'Specifies the tax rate for bracket 4.';
                }

            }
        }
    }

    trigger OnOpenPage()
    var
        PHPayrollSetup: Record "PH Payroll Setup";
    begin
        // Use a more robust approach to check if a record exists and get it
        if not Rec.Get('DEFAULT') then begin
            // Only insert if the record doesn't exist
            Clear(Rec);
            Rec.Init();
            Rec.PrimaryKey := 'DEFAULT';
            Rec.Insert(true);  // Use true to enable error handling
        end;

        // Force a refresh of the page with the existing/new record
        CurrPage.Update(false);
    end;
}