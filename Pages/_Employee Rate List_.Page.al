page 50100 "Employee Rate List"
{
    ApplicationArea = All;
    Caption = 'Employee Rate List';
    PageType = List;
    SourceTable = "Employee Data";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EmployeeId; Rec.EmployeeId)
                {
                }
                field(EmployeeNo; Rec.EmployeeNo)
                {
                }
                // First Name and Last Name from Employee table
                field(FirstName; FirstName)
                {
                    Caption = 'First Name';
                    Editable = false;
                }
                field(LastName; LastName)
                {
                    Caption = 'Last Name';
                    Editable = false;
                }
                field(Position; Rec.Position)
                {
                }
                field(Rate; Rec.Rate)
                {
                }
                field(EffectivityDate; Rec.EffectivityDate)
                {
                }
                field(TIN; Rec.TIN)
                {
                }
                field(SSS; Rec.SSS)
                {
                }
                field(PhilHealth; Rec.PhilHealth)
                {
                }
                field(PagIBIG; Rec.PagIBIG)
                {
                }
                field(BankAccountNo; Rec.BankAccountNo)
                {
                }
                field(BankName; Rec.BankName)
                {
                }
                field(HireDate; Rec.HireDate)
                {
                }
                field(PayFrequency; Rec.PayFrequency)
                {
                }
                field(PayType; Rec.PayType)
                {
                }
                field(OvertimeRate; Rec.OvertimeRate)
                {
                }
                field(HolidayRate; Rec.HolidayRate)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }

                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ViewPayrollEntries)
            {
                ApplicationArea = All;
                Caption = 'View Payroll Entries';
                Image = List;
                ToolTip = 'View payroll entries for this employee';
                RunObject = Page "Payroll Entry List";
                RunPageLink = EmployeeId = field(EmployeeId);

                trigger OnAction()
                begin
                    // Navigation handled by RunObject properties
                end;
            }

            action(CreatePayrollEntry)
            {
                ApplicationArea = All;
                Caption = 'Create New Payroll Entry';
                Image = NewDocument;
                ToolTip = 'Create a new payroll entry for this employee';

                trigger OnAction()
                var
                    PayrollEntry: Record "Payroll Entry";
                begin
                    PayrollEntry.Init();
                    PayrollEntry.Status := PayrollEntry.Status::Draft;
                    PayrollEntry.EmployeeId := Rec.EmployeeId;
                    PayrollEntry.GrossPay := Rec.Rate;
                    PayrollEntry.PostDate := WorkDate();
                    PayrollEntry.PeriodStart := CalcDate('<-CM>', WorkDate());
                    PayrollEntry.PeriodEnd := CalcDate('<CM>', WorkDate());
                    PayrollEntry.Insert(true);

                    Commit(); // Commit the new record

                    // Open the card page for the newly created entry
                    Page.Run(50103, PayrollEntry);
                end;
            }
        }
    }

    var
        EmployeeRec: Record Employee;
        FirstName: Text[50];
        LastName: Text[50];

    trigger OnAfterGetRecord()
    begin
        Clear(FirstName);
        Clear(LastName);
        if EmployeeRec.Get(Rec.EmployeeNo) then begin
            FirstName := EmployeeRec."First Name";
            LastName := EmployeeRec."Last Name";
        end;
    end;
}
