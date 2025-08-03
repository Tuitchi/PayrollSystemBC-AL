page 50103 "Payroll Entry Card"
{
    ApplicationArea = All;
    Caption = 'Payroll Entry';
    PageType = Card;
    SourceTable = "Payroll Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the entry number of the payroll entry.';
                    Editable = StatusIsDraft;

                    trigger OnAssistEdit()
                    begin
                        if Rec.EntryNo = '' then
                            Rec.EntryNo := GetNextEntryNo();
                    end;
                }
                field(EmployeeId; Rec.EmployeeId)
                {
                    ToolTip = 'Specifies the employee number for this payroll entry.';
                    TableRelation = "Employee Data".EmployeeId;
                    LookupPageId = "Employee Rate List";
                    trigger OnValidate()
                    begin
                        if EmployeeRateRec.Get(Rec.EmployeeId) then begin
                            EmployeeNo := EmployeeRateRec.EmployeeNo;
                            Position := EmployeeRateRec.Position;
                            EffectivityDate := EmployeeRateRec.EffectivityDate;
                            if EmployeeRec.Get(EmployeeRateRec.EmployeeNo) then begin
                                TIN := EmployeeRec.TIN;
                                SSS := EmployeeRec.SSS;
                                PhilHealth := EmployeeRec.PhilHealth;
                                PagIBIG := EmployeeRec.PagIBIG;
                                BankAccountNo := EmployeeRec.BankAccountNo;
                                BankName := EmployeeRec.BankName;
                            end;
                            Rec.GrossPay := EmployeeRateRec.Rate;

                            // Use EmployeeNo to fetch from standard Employee table
                            if EmployeeRec.Get(EmployeeRateRec.EmployeeNo) then begin
                                FirstName := EmployeeRec."First Name";
                                LastName := EmployeeRec."Last Name";
                            end;
                        end;
                    end;
                }
                field(EmployeeNo; EmployeeNo)
                {
                    Caption = 'Employee No.';
                    Editable = false;
                }
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
                field(Position; Position)
                {
                    Caption = 'Position';
                    Editable = false;
                }
                field(EffectivityDate; EffectivityDate)
                {
                    Caption = 'Effectivity Date';
                    Editable = false;
                }

                field(BankAccountNo; BankAccountNo)
                {
                    Caption = 'Bank Account No.';
                    Editable = false;
                }
                field(BankName; BankName)
                {
                    Caption = 'Bank Name';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the payroll entry.';
                    Editable = false;
                }
            }

            group(Earnings)
            {
                Caption = 'Earnings';

                field(GrossPay; Rec.GrossPay)
                {
                    Caption = 'Gross Pay';
                    Editable = StatusIsDraft;
                }
            }

            group(Deductions)
            {
                Caption = 'Deductions';

                group(IDNumbers)
                {
                    Caption = 'Government IDs';

                    field(TIN; TIN)
                    {
                        Caption = 'TIN';
                        ToolTip = 'Tax Identification Number from Employee Data';
                        Editable = false;
                    }
                    field(SSS; SSS)
                    {
                        Caption = 'SSS Number';
                        ToolTip = 'Social Security System Number from Employee Data';
                        Editable = false;
                    }
                    field(PhilHealth; PhilHealth)
                    {
                        Caption = 'PhilHealth Number';
                        ToolTip = 'PhilHealth Number from Employee Data';
                        Editable = false;
                    }
                    field(PagIBIG; PagIBIG)
                    {
                        Caption = 'Pag-IBIG Number';
                        ToolTip = 'Pag-IBIG Number from Employee Data';
                        Editable = false;
                    }
                }

                group(AmountsPaid)
                {
                    Caption = 'Amounts';
                    field(SSSAmount; Rec.SSSAmount)
                    {
                        Caption = 'SSS Contribution';
                        ToolTip = 'SSS contribution amount for this pay period';
                        Editable = false;
                    }
                    field(PagibigAmt; Rec.PagibigAmt)
                    {
                        Caption = 'Pag-IBIG Contribution';
                        ToolTip = 'Pag-IBIG contribution amount for this pay period';
                        Editable = false;
                    }
                    field(PhilHealthAmt; Rec.PhilHealthAmt)
                    {
                        Caption = 'PhilHealth Contribution';
                        ToolTip = 'PhilHealth contribution amount for this pay period';
                        Editable = false;
                    }

                    field(TaxAmount; Rec.TaxAmount)
                    {
                        Caption = 'Withholding Tax';
                        ToolTip = 'Withholding tax amount for this pay period';
                        Editable = false;
                    }
                    field(OtherDed; Rec.OtherDed)
                    {
                        Caption = 'Other Deductions';
                        ToolTip = 'Other deductions for this pay period';
                        Enabled = StatusIsDraft;
                    }
                }
            }

            group(Total)
            {
                Caption = 'Total';

                field(NetPay; Rec.NetPay)
                {
                    ToolTip = 'Specifies the net pay amount for this payroll entry.';
                    Style = Strong;
                }

                field(TotalDeductions; Rec.SSSAmount + Rec.PagibigAmt + Rec.PhilHealthAmt + Rec.TaxAmount + Rec.OtherDed)
                {
                    Caption = 'Total Deductions';
                    Editable = false;
                }

                field(EmployeeHistoryNetPay; EmployeeHistoryNetPay)
                {
                    Caption = 'Total Net Pay (Employee History)';
                    ToolTip = 'Shows the total net pay for this employee across all payroll entries.';
                    Editable = false;
                    Style = Strong;
                }

                field(EmployeeHistoryEntries; EmployeeHistoryEntries)
                {
                    Caption = 'Total Payroll Entries (Employee)';
                    ToolTip = 'Shows the total number of payroll entries for this employee.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Calculate")
            {
                ApplicationArea = All;
                Caption = 'Calculate';
                Image = Calculate;
                ToolTip = 'Recalculate the payroll entry.';
                Enabled = StatusIsDraft;

                trigger OnAction()
                var
                    PayrollCalc: Codeunit "Payroll Calculations";
                    CurrentDate: Date;
                begin
                    // Use Payroll Calculations codeunit for all deduction and net pay calculations
                    CurrentDate := WorkDate();

                    // Calculate SSS, PhilHealth, PagIBIG using codeunit
                    Rec.SSSAmount := PayrollCalc.CalculateSSS(Rec.GrossPay, CurrentDate);
                    Rec.PhilHealthAmt := PayrollCalc.CalculatePhilHealth(Rec.GrossPay, CurrentDate);
                    Rec.PagibigAmt := PayrollCalc.CalculatePagIBIG(Rec.GrossPay);

                    // Calculate Tax using codeunit
                    Rec.TaxAmount := PayrollCalc.CalculateTax(Rec.GrossPay, Rec.SSSAmount, Rec.PhilHealthAmt, Rec.PagibigAmt);

                    // Calculate Net Pay using codeunit
                    Rec.NetPay := PayrollCalc.CalculateNetPay(Rec.GrossPay, Rec.SSSAmount, Rec.PhilHealthAmt, Rec.PagibigAmt, Rec.TaxAmount, Rec.OtherDed);

                    Rec.Modify(true);
                    CurrPage.Update(false);

                    Message('Deductions recalculated using Payroll Calculations codeunit: SSS: %1, Pag-IBIG: %2, PhilHealth: %3',
                        Rec.SSSAmount, Rec.PagibigAmt, Rec.PhilHealthAmt);
                end;
            }

            action("Release")
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                ToolTip = 'Change the status of the payroll entry to Released.';
                Enabled = StatusIsDraft;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Draft then begin
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Reopen")
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                ToolTip = 'Change the status of the payroll entry back to Draft.';
                Enabled = StatusIsReleased;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Released then begin
                        Rec.Status := Rec.Status::Draft;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        StatusIsDraft := Rec.Status = Rec.Status::Draft;
        StatusIsReleased := Rec.Status = Rec.Status::Released;
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(FirstName);
        Clear(LastName);
        Clear(EmployeeNo);
        Clear(Position);
        Clear(EffectivityDate);
        Clear(TIN);
        Clear(SSS);
        Clear(PhilHealth);
        Clear(PagIBIG);
        Clear(BankAccountNo);
        Clear(BankName);
        Clear(EmployeeHistoryNetPay);
        Clear(EmployeeHistoryEntries);

        if EmployeeRateRec.Get(Rec.EmployeeId) then begin
            EmployeeNo := EmployeeRateRec.EmployeeNo;
            Position := EmployeeRateRec.Position;
            EffectivityDate := EmployeeRateRec.EffectivityDate;
            if EmployeeRec.Get(EmployeeRateRec.EmployeeNo) then begin
                TIN := EmployeeRec.TIN;
                SSS := EmployeeRec.SSS;
                PhilHealth := EmployeeRec.PhilHealth;
                PagIBIG := EmployeeRec.PagIBIG;
                BankAccountNo := EmployeeRec."Bank Account No.";
                BankName := EmployeeRec.BankName;
            end;

            // Use EmployeeNo to fetch from standard Employee table
            if EmployeeRec.Get(EmployeeRateRec.EmployeeNo) then begin
                FirstName := EmployeeRec."First Name";
                LastName := EmployeeRec."Last Name";
            end;

            // Fetch Payroll Setup for rates

            // Calculate employee history totals
            CalculateEmployeeHistory();
        end;
    end;

    var
        StatusIsDraft: Boolean;
        StatusIsReleased: Boolean;
        EmployeeRateRec: Record "Employee Data";
        EmployeeRec: Record Employee;
        FirstName: Text[50];
        LastName: Text[50];
        EmployeeNo: Code[20];
        Position: Text[50];
        EffectivityDate: Date;
        TIN: Code[20];
        SSS: Code[20];
        PhilHealth: Code[20];
        PagIBIG: Code[20];
        BankAccountNo: Code[30];
        BankName: Text[100];
        EmployeeHistoryNetPay: Decimal;
        EmployeeHistoryEntries: Integer;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Initialize new record with reasonable defaults
        Rec.EntryNo := GetNextEntryNo();
        Rec.PostDate := WorkDate();
        Rec.Status := Rec.Status::Draft;

        // Initialize period start/end based on current date
        Rec.PeriodStart := CalcDate('<-CM>', WorkDate());  // First day of current month
        Rec.PeriodEnd := CalcDate('<CM>', WorkDate());     // Last day of current month

        StatusIsDraft := true;
        StatusIsReleased := false;

    end;

    local procedure CalculateEmployeeHistory()
    var
        PayrollEntry: Record "Payroll Entry";
    begin
        Clear(EmployeeHistoryNetPay);
        Clear(EmployeeHistoryEntries);

        PayrollEntry.Reset();
        PayrollEntry.SetRange(EmployeeId, Rec.EmployeeId);

        if PayrollEntry.FindSet() then
            repeat
                EmployeeHistoryNetPay += PayrollEntry.NetPay;
                EmployeeHistoryEntries += 1;
            until PayrollEntry.Next() = 0;
    end;

    local procedure GetNextEntryNo(): Code[20]
    var
        PayrollEntry: Record "Payroll Entry";
        LastEntryNo: Integer;
        NextEntryNo: Integer;
    begin
        PayrollEntry.Reset();
        if PayrollEntry.FindLast() then begin
            // Try to convert the last entry number to integer
            if Evaluate(LastEntryNo, PayrollEntry.EntryNo) then
                NextEntryNo := LastEntryNo + 1
            else
                NextEntryNo := 1;
        end else
            NextEntryNo := 1;

        // Format with leading zeros
        exit(Format(NextEntryNo, 0, '<Integer,10><Filler,0>'));
    end;
}