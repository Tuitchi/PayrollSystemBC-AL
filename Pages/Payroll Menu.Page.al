page 50105 "Payroll Menu"
{
    ApplicationArea = All;
    Caption = 'Payroll Management';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(MasterData)
            {
                Caption = 'Master Data';

                field(EmployeesLink; 'View Employees')
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'View the list of employees.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(50104); // Payroll Employee List
                    end;
                }
            }

            group(Transactions)
            {
                Caption = 'Transactions';

                field(PayrollEntriesLink; 'Payroll Entries')
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'View and manage payroll entries.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(50102); // Payroll Entry List
                    end;
                }

                field(DailyTimeRecordsLink; 'Daily Time Records')
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'View and manage employee attendance records.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(50107); // Daily Time Record List
                    end;
                }

                field(NewPayrollEntryLink; 'New Payroll Entry')
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Create a new payroll entry.';

                    trigger OnDrillDown()
                    var
                        PayrollEntry: Record "Payroll Entry";
                    begin
                        PayrollEntry.Init();
                        PayrollEntry.PostDate := WorkDate();
                        PayrollEntry.PeriodStart := CalcDate('<-14D>', WorkDate());
                        PayrollEntry.PeriodEnd := WorkDate();
                        PayrollEntry.Insert(true);
                        Page.Run(50103, PayrollEntry); // Payroll Entry Card
                    end;
                }
            }
        }
    }
}