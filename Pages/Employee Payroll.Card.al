page 50108 "Employee Payroll Card"
{
    PageType = Card;
    SourceTable = Employee;
    Caption = 'Employee Payroll Information';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                    Importance = Promoted;
                }
                field(FullName; Rec.FullName())
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(JobTitle; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
            }

            group(PayrollDetails)
            {
                Caption = 'Payroll Details';
                field(PayFrequency; Rec.PayFrequency)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how often this employee is paid.';
                    Importance = Promoted;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base rate for this employee.';
                    Visible = not IsRateObsolete;
                    Importance = Promoted;
                }
                field(AlternativeRateField; Rec.Rate)
                {
                    Caption = 'Base Salary';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base salary for monthly employees.';
                    Visible = IsRateObsolete;
                    Importance = Promoted;
                }
            }

            group(GovernmentIDs)
            {
                Caption = 'Government IDs';
                field(TIN; Rec.TIN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tax Identification Number.';
                    Importance = Promoted;
                }
                field(SSS; Rec.SSS)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Social Security System number.';
                }
                field(PhilHealth; Rec.PhilHealth)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PhilHealth number.';
                }
                field(PagIBIG; Rec.PagIBIG)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Pag-IBIG number.';
                }
            }

            group(BankInformation)
            {
                Caption = 'Bank Information';
                field(BankName; Rec.BankName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the bank where salary will be deposited.';
                    Importance = Promoted;
                }
                field(BankAccountNo; Rec.BankAccountNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bank account number for salary deposit.';
                    Importance = Promoted;
                }
            }
        }

        area(FactBoxes)
        {
            // part(PayrollStatistics; "Employee Payroll Statistics")
            // {
            //     ApplicationArea = All;
            //     SubPageLink = "Employee No." = field("No.");
            //     Caption = 'Payroll Statistics';
            // }
        }
    }

    actions
    {
        area(Processing)
        {
            // action(ViewPayHistory)
            // {
            //     ApplicationArea = All;
            //     Caption = 'View Pay History';
            //     Image = History;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     ToolTip = 'View historical payroll information for this employee.';

            //     trigger OnAction()
            //     var
            //         PayrollEntries: Page "Payroll Entries";
            //         PayrollEntry: Record "Payroll Entry";
            //     begin
            //         PayrollEntry.SetRange("Employee No.", Rec."No.");
            //         PayrollEntries.SetTableView(PayrollEntry);
            //         PayrollEntries.Run();
            //     end;
            // }
        }
    }

    trigger OnOpenPage()
    begin
        IsRateObsolete := Rec.Rate = 0; // Simple check for obsolete field
    end;

    var
        IsRateObsolete: Boolean;
}